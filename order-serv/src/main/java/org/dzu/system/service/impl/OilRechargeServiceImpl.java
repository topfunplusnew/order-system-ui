package org.dzu.system.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import org.dzu.common.constant.DelConstants;
import org.dzu.common.constant.OilRechargeConstant;
import org.dzu.common.enums.TableName;
import org.dzu.common.exception.ServiceException;
import org.dzu.common.utils.DateUtils;
import org.dzu.common.utils.SecurityUtils;
import org.dzu.common.utils.StringUtils;
import org.dzu.system.domain.BankAccount;
import org.dzu.system.domain.OilCard;
import org.dzu.system.domain.OilRecharge;
import org.dzu.system.mapper.OilCardConsumeMapper;
import org.dzu.system.mapper.OilCardMapper;
import org.dzu.system.mapper.OilRechargeMapper;
import org.dzu.system.service.IBankAccountService;
import org.dzu.system.service.IOilRechargeService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Isolation;
import org.springframework.transaction.annotation.Transactional;

import java.util.Arrays;
import java.util.List;

@Service
public class OilRechargeServiceImpl implements IOilRechargeService {

    @Autowired
    private OilRechargeMapper oilRechargeMapper;
    @Autowired
    private IBankAccountService bankAccountService;
    @Autowired
    private OilCardMapper oilCardMapper;
    @Autowired
    private OilCardConsumeMapper oilCardConsumeMapper;
    @Autowired
    private OilCardServiceImpl oilCardServiceImpl;
    @Autowired
    private PaymentApplyServiceImpl paymentApplyServiceImpl;

    @Override
    public OilRecharge selectOilRechargeById(Long id) {
        return oilRechargeMapper.selectOilRechargeById(id);
    }

    /**
     * 查询加油卡充值信息列表
     *
     * @param oilRecharge 加油卡充值信息
     * @return 加油卡充值信息
     */
    @Override
    public List<OilRecharge> selectOilRechargeList(OilRecharge oilRecharge) {
        return oilRechargeMapper.selectOilRechargeList(oilRecharge);
    }

    /**
     * 新增加油卡充值信息
     *
     * @param oilRecharge 加油卡充值信息
     * @return 结果
     */
    @Override
    @Transactional(isolation = Isolation.SERIALIZABLE, rollbackFor = Exception.class)
    public int insertOilRecharge(OilRecharge oilRecharge) {
        // 设置基础信息
        oilRecharge.setAddtime(String.valueOf(DateUtils.getNowDate()));
        oilRecharge.setUserId(SecurityUtils.getUserId());
        oilRecharge.setUserName(SecurityUtils.getUserTruename());
        oilRecharge.setDelFlag(Long.valueOf(DelConstants.NODEL));

        // 检测对应的油卡是否存在
        QueryWrapper<OilCard> query = new QueryWrapper<OilCard>().eq("oilCardNo", oilRecharge.getOilCardNo()).eq("delFlag", DelConstants.NODEL);
        OilCard oilCard = oilCardMapper.selectOne(query);
        if (oilCard == null) {
            throw new ServiceException("油卡不存在");
        }

        // 判断现金还是银行卡充值
        if (OilRechargeConstant.BankCord.equals(oilRecharge.getRechargeType())) {
            BankAccount bankAccount = bankAccountService.selectBankAccountByBankNo(oilRecharge.getBankNo());
            if (bankAccount == null) {
                throw new ServiceException("银行卡号不存在");
            }
        } else {
            // 现金充值,进行油卡金额变动
//            oilCardServiceImpl.updateOilCardMoney(oilRecharge.getOilCardNo(), oilRecharge.getRechargeMoney());
            // 目前客户的逻辑似乎是无论现金还是银行卡,都是审核通过后变动,此处先进行注释
        }
        return oilRechargeMapper.insertOilRecharge(oilRecharge);
    }

    /**
     * 修改加油卡充值信息
     *
     * @param oilRecharge 加油卡充值信息
     * @return 结果
     */
    @Override
    @Transactional(isolation = Isolation.SERIALIZABLE, rollbackFor = Exception.class)
    public int updateOilRecharge(OilRecharge oilRecharge) {
        // 搜索旧充值信息
        OilRecharge oldOilRecharge = oilRechargeMapper.selectOilRechargeById(oilRecharge.getId());

        // 设置基础信息
        oilRecharge.setUpdateTime(DateUtils.getNowDate());
        // 如果修改了充值方式,则拒绝
        if (!StringUtils.equals(oldOilRecharge.getRechargeType(), oilRecharge.getRechargeType())) {
            throw new ServiceException("充值方式不支持修改");
        }
        // 如果修改了油卡卡号,则拒绝
        if (!StringUtils.equals(oldOilRecharge.getOilCardNo(), oilRecharge.getOilCardNo())) {
            throw new ServiceException("油卡卡号不支持修改");
        }

        // 判断审核信息
        if (paymentApplyServiceImpl.checkExist(TableName.OIL_RECHARGE.get(), oilRecharge.getId())) {
            throw new ServiceException("存在正在进行或者已经通过的审核信息,不可修改");
        }
        // 判断现金还是银行卡充值
        if (OilRechargeConstant.BankCord.equals(oilRecharge.getRechargeType())) {

            BankAccount bankAccount = bankAccountService.selectBankAccountByBankNo(oilRecharge.getBankNo());
            if (bankAccount == null) {
                throw new ServiceException("银行卡号不存在");
            }
        } else {
//            // 现金充值  先把旧充值金额归还,再把新充值金额加入
//            oilCardServiceImpl.updateOilCardMoney(oldOilRecharge.getOilCardNo(), -oldOilRecharge.getRechargeMoney());
//            oilCardServiceImpl.updateOilCardMoney(oilRecharge.getOilCardNo(), oilRecharge.getRechargeMoney());
            // 此处注释原因同新增
        }

        return oilRechargeMapper.updateOilRecharge(oilRecharge);
    }

    /**
     * 批量删除加油卡充值信息
     *
     * @param ids 需要删除的加油卡充值信息主键
     * @return 结果
     */
    @Override
    @Transactional(isolation = Isolation.SERIALIZABLE, rollbackFor = Exception.class)
    public int deleteOilRechargeByIds(Long[] ids) {
        // 搜索本次删除的充值信息
        List<OilRecharge> oilRecharges = oilRechargeMapper.selectBatchIds(Arrays.asList(ids));
        for (OilRecharge oilRecharge : oilRecharges) {
            // 根据充值方式做不同的针对判断
            if (paymentApplyServiceImpl.checkExist(TableName.OIL_RECHARGE.get(), oilRecharge.getId())) {
                throw new ServiceException("存在正在进行或者已经通过的审核信息,不可删除");
            }
        }

        return oilRechargeMapper.deleteOilRechargeByIds(ids);
    }
}
