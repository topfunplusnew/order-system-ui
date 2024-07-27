package org.dzu.system.service.impl;

import org.dzu.common.constant.OrderConstants;
import org.dzu.common.core.domain.model.LoginUser;
import org.dzu.common.utils.DateUtils;
import org.dzu.common.utils.SecurityUtils;
import org.dzu.common.utils.reflect.ReflectUtils;
import org.dzu.system.domain.Bankacceptance;
import org.dzu.system.domain.Goodsorder;
import org.dzu.system.domain.Orderdetail;
import org.dzu.system.mapper.BankacceptanceMapper;
import org.dzu.system.mapper.OrderdetailMapper;
import org.dzu.system.service.IBankacceptanceService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.stream.Collectors;

/**
 * 商业票据、银行承兑Service业务层处理
 * 
 * @author ml
 * @date 2024-07-19
 */
@Service
public class BankacceptanceServiceImpl implements IBankacceptanceService {
    @Autowired
    private BankacceptanceMapper bankacceptanceMapper;

    /**
     * 查询商业票据、银行承兑
     *
     * @param id 商业票据、银行承兑主键
     * @return 商业票据、银行承兑
     */
    @Override
    public Bankacceptance selectBankacceptanceById(Long id) {
        return bankacceptanceMapper.selectBankacceptanceById(id);
    }

    /**
     * 查询商业票据、银行承兑列表
     *
     * @param bankacceptance 商业票据、银行承兑
     * @return 商业票据、银行承兑
     */
    @Override
    public List<Bankacceptance> selectBankacceptanceList(Bankacceptance bankacceptance) {
        return bankacceptanceMapper.selectBankacceptanceList(bankacceptance);
    }

    /**
     * 新增商业票据、银行承兑
     *
     * @param bankacceptance 商业票据、银行承兑
     * @return 结果
     */
    @Transactional(rollbackFor = Exception.class)
    // TODO：开启事务？ 不需要，一并成功，一并失败
    @Override
    public int insertBankacceptance(Bankacceptance bankacceptance) {
        // TODO ： 增加时间，操作人，操作人id
        return bankacceptanceMapper.insertBankacceptance(bankacceptance);
    }

    /**
     * 修改商业票据、银行承兑
     *
     * @param bankacceptance 商业票据、银行承兑
     * @return 结果
     */
    @Transactional(rollbackFor = Exception.class)
    // TODO： spring 的事务管理，只有出现RuntimeException，才会触发事务
    // 直接指定所以异常都需要回滚
    @Override
    public int updateBankacceptance(Bankacceptance bankacceptance) {
        LoginUser loginUser = SecurityUtils.getLoginUser();
        bankacceptance.setUserId(loginUser.getUserId());
        bankacceptance.setUserName(loginUser.getUser().getTrueName());
        // TODO ： addtime、UserName，操作人时间、名字啥的
//        ReflectUtils.modfiyPersonInfo(bankacceptance,loginUser.getUser());


        //旧数据备份
        bankacceptanceMapper.copyToBack(new Long[]{bankacceptance.getId()});
        List<Long> collect = bankacceptance.getbankList().stream().map(Bankacceptance::getId).collect(Collectors.toList());
        bankacceptanceMapper.copyToBack((Long[]) collect.toArray());
        // 订单是一个主子表  主表是商品表， 子表是订单详情表   一个商品表的信息关联 若干个订单详情表
        // TODO 记得修改
        //新数据修改
        bankacceptance.setUpdateTime(DateUtils.getNowDate());
        //TODO  打印语句 。。帮助你调试的这些语句
        System.out.println(bankacceptance.getId());

        bankacceptanceMapper.deleteBankacceptanceById(bankacceptance.getId());

        insertBankacceptance(bankacceptance);
        return bankacceptanceMapper.updateBankacceptance(bankacceptance);
    }

    /**
     * 批量删除商业票据、银行承兑
     *
     * @param ids 需要删除的商业票据、银行承兑主键
     * @return 结果
     */
    @Override
    public int deleteBankacceptanceByIds(Long[] ids)
    {
//        // 操作下压到数据库
//        for (Long id : ids) {
//            // 产生 ids.sizi * 2 个sql语句
//            // 根据id查询数据，根据数据查询id，根据数据的id删除数据
//             // TODO： 直接根据id删除数据
//            Bankacceptance bankacceptance = bankacceptanceMapper.selectBankacceptanceById(id);
//            bankacceptanceMapper.deleteBankacceptanceByIds(new Long[]{bankacceptance.getId()});
//        }
        return bankacceptanceMapper.deleteBankacceptanceByIds(ids);
    }

    /**
     * 删除商业票据、银行承兑信息
     * 
     * @param id 商业票据、银行承兑主键
     * @return 结果
     */
    @Override
    public int deleteBankacceptanceById(Long id)
    {
        bankacceptanceMapper.deleteBankacceptanceById(selectBankacceptanceById(id).getId());
        //TODO ： 根据ID拿到ID   无用操作
        return bankacceptanceMapper.deleteBankacceptanceById(id);
    }
}
