package org.dzu.system.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import org.dzu.common.constant.DelConstants;
import org.dzu.common.constant.OrderConstants;
import org.dzu.common.constant.YesOrNoConstants;
import org.dzu.common.core.domain.entity.SysRole;
import org.dzu.common.exception.ServiceException;
import org.dzu.common.utils.DateUtils;
import org.dzu.common.utils.SecurityUtils;
import org.dzu.common.utils.StringUtils;
import org.dzu.common.utils.uuid.UUID;
import org.dzu.system.domain.*;
import org.dzu.system.mapper.GoodsOrderMapper;
import org.dzu.system.mapper.PaymentMapper;
import org.dzu.system.service.*;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.*;

/**
 * 订单Service业务层处理
 *
 * @author ml
 * @date 2024-08-02
 */
@Service
public class GoodsOrderServiceImpl implements IGoodsOrderService {
    @Autowired
    private GoodsOrderMapper goodsOrderMapper;

    @Autowired
    private ICarsService carsService;

    @Autowired
    private IBankAccountService bankAccountService;

    @Autowired
    private ICompanyService companyService;

    @Autowired
    private IOrderDetailService orderDetailService;

    @Autowired
    private PaymentMapper paymentMapper;

    @Autowired
    private ISysConfigService configService;

    /**
     * 查询订单
     *
     * @param id 订单主键
     * @return 订单
     */
    @Override
    public GoodsOrder selectGoodsOrderById(Long id) {
        return goodsOrderMapper.selectGoodsOrderById(id);
    }

    /**
     * 查询订单列表
     *
     * @param goodsOrder 订单
     * @return 订单
     */
    @Override
    public List<GoodsOrder> selectGoodsOrderList(GoodsOrder goodsOrder) {
        // 校验权限，决定能看到的数据
        preDataScope(goodsOrder);
        // 校验一下开始和结束时间戳是否是纯数字
        if (StringUtils.isNotEmpty(goodsOrder.getOrderDateStart()) && !StringUtils.isNumeric(goodsOrder.getOrderDateStart())) {
            throw new ServiceException("开始时间戳不合法");
        }
        if (StringUtils.isNotEmpty(goodsOrder.getOrderDateEnd()) && !StringUtils.isNumeric(goodsOrder.getOrderDateEnd())) {
            throw new ServiceException("结束时间戳不合法");
        }

        return goodsOrderMapper.selectGoodsOrderList(goodsOrder);
    }

    /**
     * 新增订单
     *
     * @param goodsOrder 订单
     * @return 结果
     */
    @Transactional
    @Override
    public int insertGoodsOrder(GoodsOrder goodsOrder) {


        // 设置基础信息
        goodsOrder.setAddtime(String.valueOf(DateUtils.getNowDate()));
        goodsOrder.setUserId(SecurityUtils.getUserId());
        goodsOrder.setUserName(SecurityUtils.getUserTruename());
        goodsOrder.setCancelFlag(Long.valueOf(DelConstants.NODEL));


        // 校验所依赖的其他表的数据
        Vaildate(goodsOrder);


        // 设置订单号
        goodsOrder.setOrdersNo(UUID.fastUUID().toString());


        // 新增一定不是调整单
        goodsOrder.setIsAdjust(YesOrNoConstants.NO_zh);
        goodsOrder.setIsAdjusted(YesOrNoConstants.NO_zh);
        goodsOrder.setAdjustOrderid(null);
        goodsOrder.setAdjustDate(null);
        // 新增一定不可能被审核
//        goodsOrder.setA
        goodsOrder.setCheckState(OrderConstants.ORDER_STATUS_AUDIT_NO_PASS);
        goodsOrder.setCheckUserId(null);
        //是否可编辑为是
        goodsOrder.setIsedit(Long.valueOf(YesOrNoConstants.YES_num));

        // 计算陆运费和海运费和商家姓名，方便以后查询减少查询次数
        preFreightAndSupplier(goodsOrder);


        // 先插入主表后插入子表
        int rows = goodsOrderMapper.insertGoodsOrder(goodsOrder);
        insertOrderDetail(goodsOrder);
        return rows;
    }


    /**
     * 修改订单
     *
     * @param goodsOrder 订单
     * @return 结果
     */
    @Transactional
    @Override
    public int updateGoodsOrder(GoodsOrder goodsOrder) {



        // 设置基础数据
        goodsOrder.setUpdateTime(DateUtils.getNowDate());

        // 获取数据库中的旧数据
        GoodsOrder oldOrder = goodsOrderMapper.selectGoodsOrderById(goodsOrder.getId());
        if (oldOrder == null) {
            throw new ServiceException("数据库搜索失败,请刷新页面后重试");
        }

        // 如果可编辑选项为否，不允许修改
        if (oldOrder.getIsedit() == YesOrNoConstants.NO_num) {
            throw new ServiceException("本订单已不允许修改");
        }

        // 防止修改审核状态
        goodsOrder.setCheckState(null);
        goodsOrder.setCheckUserId(null);

        // 备份数据
        // 原型复制一份goodsOrder, 因为需要改动数据，防止对现有的进行干扰
        GoodsOrder back = new GoodsOrder();
        BeanUtils.copyProperties(oldOrder, back);
        ToBack(back);


        // 获取系统设置里面的允许修改时间
        String s = configService.selectConfigByKey("order.order.update.timelimit");
        if (StringUtils.isEmpty(s)) {
            throw new ServiceException("获取系统设置失败，请联系管理员");
        }
        // 如果设置的时间不是数字，抛出异常
        if (!StringUtils.isNumeric(s)) {
            throw new ServiceException("系统设置的时间不合法，请联系管理员");
        }
        int limit = 0;
        // 转换成数字
        try {
            limit = Integer.parseInt(s);
            if (limit <= 0) {
                throw new ServiceException("系统设置的时间不合法，请联系管理员");
            }
        } catch (Exception e) {
            throw new ServiceException("系统设置的时间不合法，请联系管理员");
        }


        // 如果距离addtime的时间超过设置的分钟，拒绝修改. 先将addtime从字符串转会Date再进行运算
        if (DateUtils.differentMinutesByMillisecond(new Date(oldOrder.getAddtime()), DateUtils.getNowDate()) > limit) {
            throw new ServiceException("超过修改时间限制:"+limit+"分钟,不允许修改");
        }


        // 先校验有没有改动uuid
        if (StringUtils.equals(oldOrder.getOrdersNo(), goodsOrder.getOrdersNo())) {
            throw new ServiceException("订单号不允许修改");
        }
        // 补充uuid便于其他表的查询
        goodsOrder.setOrdersNo(oldOrder.getOrdersNo());
        // 检查依赖的其他表
        Vaildate(goodsOrder);

        // 计算陆运费和海运费和商家姓名，方便以后查询减少查询次数
        preFreightAndSupplier(goodsOrder);


        // 删除后插入，模拟成更新
        orderDetailService.deleteOrderDetailByOrderId(goodsOrder);
        int rows = goodsOrderMapper.updateGoodsOrder(goodsOrder);
        insertOrderDetail(goodsOrder);

        return rows;
    }


    /**
     * 审核订单
     *
     * @param id 订单
     * @return 结果
     */
    @Transactional
    @Override
    public int auditGoodsOrder(Long id, boolean isAudit) {
        // 先搜索旧数据
        GoodsOrder oldOrder = goodsOrderMapper.selectGoodsOrderById(id);
        if (oldOrder == null) {
            throw new ServiceException("数据库搜索失败,请刷新页面后重试");
        }
        // 更改状态
        if (isAudit) {
            // 本次需要修改为已经审核
            oldOrder.setCheckState(OrderConstants.ORDER_STATUS_AUDIT_PASS);
            oldOrder.setCheckUserId(SecurityUtils.getUserId());
            oldOrder.setIsedit(Long.valueOf(YesOrNoConstants.NO_num));
        } else {
            // 检擦是否满足修改为未审核的条件
            // 检查本订单是不是调整单
            if (oldOrder.getIsAdjusted().equals(YesOrNoConstants.YES_zh)) {
                throw new ServiceException("被调整单不允许修改审核状态");
            }
            // 检查是否有运费产生
            if (paymentMapper.selectCount(new QueryWrapper<Payment>().eq("tID", oldOrder.getId()).eq("tableName", "goodsorder")) > 0) {
                throw new ServiceException("已付费信息不允许修改审核状态");
            }
            // 本次需要修改为未审核并且放开修改权限
            oldOrder.setCheckState(OrderConstants.ORDER_STATUS_AUDIT_NO_PASS);
            oldOrder.setIsedit(Long.valueOf(YesOrNoConstants.YES_num));
        }
        return goodsOrderMapper.updateGoodsOrder(oldOrder);
    }

    /**
     * 调整订单
     *
     * @param goodsOrder 订单
     * @return 结果
     */
    @Transactional
    @Override
    public int adjustGoodsOrder(GoodsOrder goodsOrder) {
        // 判断已付费表里面是否有本信息，如果有，则不允许调整
        if (paymentMapper.selectCount(new QueryWrapper<Payment>().eq("tID", goodsOrder.getId()).eq("tableName", "goodsorder")) > 0) {
            throw new ServiceException("已付费信息不允许调整");
        }
        // 获取老信息
        GoodsOrder oldOrder = goodsOrderMapper.selectGoodsOrderById(goodsOrder.getId());
        if (oldOrder == null) {
            throw new ServiceException("数据库搜索失败,请刷新页面后重试");
        }
        // 如果可编辑选项为否，不允许修改
        if (oldOrder.getIsedit() == YesOrNoConstants.NO_num) {
            throw new ServiceException("本订单已不允许修改");
        }
        // 如果本身已经是调整单或者被调整单，不允许再次调整
        if (oldOrder.getIsAdjust().equals(YesOrNoConstants.YES_zh) || oldOrder.getIsAdjusted().equals(YesOrNoConstants.YES_zh)) {
            throw new ServiceException("本订单不允许再次调整");
        }

        // 逻辑需要
        goodsOrder.setAdjustOrderid(goodsOrder.getId());
        goodsOrder.setOrdersNo(oldOrder.getOrdersNo());

        // 备份数据
        // 原型复制一份goodsOrder, 因为需要改动数据，防止对现有的进行干扰
        GoodsOrder back = new GoodsOrder();
        BeanUtils.copyProperties(oldOrder, back);
        // 本次是调整
        back.setIsAdjust(YesOrNoConstants.YES_zh);
        back.getOrderDetailList().parallelStream().forEach(
                item -> {
                    item.setIsAdjusted(YesOrNoConstants.YES_zh);
                    item.setAdjustDate(DateUtils.getNowDate().toString());
                }
        );
        ToBack(back);

        // 检查依赖的其他表
        Vaildate(goodsOrder);


        // 计算陆运费和海运费和商家姓名，方便以后查询减少查询次数
        preFreightAndSupplier(goodsOrder);
        // 设置基础数据
        goodsOrder.setUpdateTime(DateUtils.getNowDate());
        // 设置调整属性
        goodsOrder.setIsAdjusted(YesOrNoConstants.YES_zh);
        goodsOrder.setAdjustDate(DateUtils.getNowDate().toString());
        //设置原来的订单和订单详情为调整单
        goodsOrder.setIsedit(Long.valueOf(YesOrNoConstants.NO_num));
        goodsOrderMapper.updateGoodsOrder(goodsOrder);
        orderDetailService.adjustOrderDetail(goodsOrder.getOrdersNo());

        // 拼接调整数据插入新的订单和订单详情
        GoodsOrder newInfo = new GoodsOrder();
        BeanUtils.copyProperties(goodsOrder, newInfo);
        newInfo.setIsAdjust(YesOrNoConstants.YES_zh);
        newInfo.setAdjustOrderid(goodsOrder.getId());
        newInfo.setIsAdjust(YesOrNoConstants.YES_zh);
        newInfo.setAdjustDate(DateUtils.getNowDate().toString());
        newInfo.setIsedit(Long.valueOf(YesOrNoConstants.YES_num));
        // 新的订单需要新的UUID
        newInfo.setOrdersNo(UUID.fastUUID().toString());
        // 新的订单的订单详情也需要修改
        newInfo.getOrderDetailList().parallelStream().forEach(
                item -> {
                    item.setIsAdjusted(YesOrNoConstants.YES_zh);
                    item.setAdjustDate(DateUtils.getNowDate().toString());
                }
        );

        // 先插入主表后插入子表
        int rows = goodsOrderMapper.insertGoodsOrder(newInfo);
        insertOrderDetail(newInfo);
        return rows;
    }

    /**
     * 批量删除订单
     *
     * @param ids 需要删除的订单主键
     * @return 结果
     */
    @Transactional
    @Override
    public int deleteGoodsOrderByIds(Long[] ids) {
        List<GoodsOrder> goodsOrders = goodsOrderMapper.selectBatchIds(Arrays.asList(ids));

        goodsOrders.forEach(
                order -> {
                    if (order.getIsedit() == YesOrNoConstants.NO_num) {
                        throw new ServiceException("含有已审核、已调整、已付运费的订单，不允许删除");
                    }
                }
        );

        for (GoodsOrder order : goodsOrders) {
            orderDetailService.deleteOrderDetailByOrderId(order);
        }
        return goodsOrderMapper.deleteGoodsOrderByIds(ids);
    }

    /**
     * 删除订单信息
     *
     * @param id 订单主键
     * @return 结果
     */
    @Transactional
    @Override
    public int deleteGoodsOrderById(Long id) {
        GoodsOrder goodsOrder = goodsOrderMapper.selectGoodsOrderById(id);

        if (goodsOrder.getIsedit() == YesOrNoConstants.NO_num) {
            throw new ServiceException("含有已审核、已调整、已付运费的订单，不允许删除");
        }

        orderDetailService.deleteOrderDetailByOrderId(goodsOrder);
        return goodsOrderMapper.deleteGoodsOrderById(id);
    }

    @Override
    public GoodsOrder selectGoodsOrderByOrderNO(String ordersNo) {
        return goodsOrderMapper.selectGoodsOrderByOrderNO(ordersNo);
    }

    /**
     * 新增订单详情信息
     *
     * @param goodsOrder 订单对象
     */
    public void insertOrderDetail(GoodsOrder goodsOrder) {
        List<OrderDetail> orderDetailList = goodsOrder.getOrderDetailList();
        if (StringUtils.isNotNull(orderDetailList)) {
            List<OrderDetail> list = new ArrayList<OrderDetail>();
            for (OrderDetail orderDetail : orderDetailList) {
                // 因为修改操作也调用了本方法，所以需要重置id为null
                orderDetail.setId(null);
                orderDetail.setOrdersNo(goodsOrder.getOrdersNo());
                // 具体的补充细节
                orderDetailService.preInsert(orderDetail);
                list.add(orderDetail);
            }
            if (list.size() > 0) {
                goodsOrderMapper.batchOrderDetail(list);
            }
        }
    }

    /**
     * 通过订单来备份订单和订单详情信息到备份表
     *
     * @param goodsOrder
     */
    private void ToBack(GoodsOrder goodsOrder) {
        // 备份订单
        backupGoodsOrder(goodsOrder);

        // 备份订单详情
        orderDetailService.backupOrderDetail(goodsOrder.getOrdersNo());
    }

    private void backupGoodsOrder(GoodsOrder goodsOrder) {
        // 捕获修改人等信息
        goodsOrder.setUserId(SecurityUtils.getUserId());
        goodsOrder.setUserName(SecurityUtils.getUserTruename());
        goodsOrder.setUpdateTime(DateUtils.getNowDate());


        GoodsorderBack back = new GoodsorderBack();
        BeanUtils.copyProperties(goodsOrder, back);
        back.setId(null);
        back.setGoodsOrderID(goodsOrder.getId());
        goodsOrderMapper.backupGoodsOrder(back);
    }

    /**
     * 校验订单的依赖数据
     *
     * @param goodsOrder
     */
    private void Vaildate(GoodsOrder goodsOrder) {
        // 检测海运和陆运司机，如果搜索不到则抛出异常
        if (goodsOrder.getLandCarID() != null && carsService.selectCarsById(goodsOrder.getLandCarID()) == null) {
            throw new ServiceException("获取陆运司机信息异常，请刷新页面后重试");
        } else {
            // 判断银行卡号是否存在
            BankAccount bankAccount = bankAccountService.selectBankAccountByBankNo(goodsOrder.getLandBankNo());
            if (bankAccount == null) {
                throw new ServiceException("获取银行卡信息异常，请刷新页面后重试");
            }
        }
        if (goodsOrder.getSeaCarID() != null && carsService.selectCarsById(goodsOrder.getSeaCarID()) == null) {
            throw new ServiceException("获取海运司机信息异常，请刷新页面后重试");
        } else {
            // 判断银行卡号是否存在
            BankAccount bankAccount = bankAccountService.selectBankAccountByBankNo(goodsOrder.getSeaBankNo());
            if (bankAccount == null) {
                throw new ServiceException("获取银行卡信息异常，请刷新页面后重试");
            }
        }

        // 判断客户是否存在
        Company company = companyService.selectCompanyById(goodsOrder.getCustomerID());
        if (company == null) {
            throw new ServiceException("获取客户信息异常，请刷新页面后重试");
        }
    }

    private static void preFreightAndSupplier(GoodsOrder goodsOrder) {
        StringJoiner sj = new StringJoiner("、");
        goodsOrder.setLandFreight(Double.valueOf(0));
        goodsOrder.setSeaFreight(Double.valueOf(0));
        goodsOrder.setAllPayments(Double.valueOf(0));

        if (goodsOrder.getOrderDetailList().size() > 0) {
            goodsOrder.getOrderDetailList().forEach(
                    item -> {
                        // 计算陆运费和海运费
                        goodsOrder.setLandFreight(goodsOrder.getLandFreight() + item.getLandFreight());
                        goodsOrder.setSeaFreight(goodsOrder.getSeaFreight() + item.getSeaFreight());
                        // 设置总货款
                        goodsOrder.setAllPayments(goodsOrder.getAllPayments() + item.getPayments());

                        // 有的订单可能没有供应商，而是仓库发货
                        if (StringUtils.isNotEmpty(item.getSupplier())) {
                            goodsOrder.setSeaFreight(goodsOrder.getSeaFreight() + item.getSeaFreight());
                            sj.add(item.getSupplier());
                        }
                    }
            );
            goodsOrder.setSupplierNames(sj.toString());
        }
    }

    private void preDataScope(GoodsOrder goodsOrder) {
        // 获取当前用户
        List<SysRole> roles = SecurityUtils.getLoginUser().getUser().getRoles();

        // 如果获取不到，代表没有绑定任何角色，后续逻辑不执行
        if (roles == null || roles.size() == 0) {
            return;
        }


        // 获取全部的数据权限，寻找最高级别 已知第一位只能是0123
        int maxValue = roles.stream()
                .map(SysRole::getDataScope)
                .filter(s -> StringUtils.isNotEmpty(s) && s.length() > 1)           // 获取每个角色的 DataScope
                .distinct()                            // 去重
                .map(scope -> scope.substring(0, scope.length() - 1))  // 去掉最后一位字符
                .mapToInt(Integer::parseInt)           // 转换为 int 类型
                .max()                                 // 求最大值
                .orElse(0);                            // 如果没有最大值，返回 0
        switch (maxValue) {
            case 1:
                // 仅能查看自己录入的
                goodsOrder.getParams().put("orderDataScope", " and userId = " + SecurityUtils.getUserId());
                break;
            case 2:
                // 对应仅自己负责的客户
                goodsOrder.getParams().put("orderDataScope", " and customerID in (select id from company where delFlag = 0 and userId = " + SecurityUtils.getUserId() + ")");

                break;
            case 3:
                // 同时满足1和2
                goodsOrder.getParams().put("orderDataScope", " and userId = " + SecurityUtils.getUserId() + " or customerID in (select id from company where delFlag = 0 and userId = " + SecurityUtils.getUserId() + ")");
                break;
            default:
                // 不做任何限制，但是拼接一个恒成立的条件
                goodsOrder.getParams().put("orderDataScope", " and 1 = 1");
                break;
        }
    }
}
