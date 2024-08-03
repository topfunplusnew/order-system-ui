package org.dzu.system.service.impl;

import java.util.List;

import org.dzu.common.constant.DelConstants;
import org.dzu.common.constant.OilRechargeConstant;
import org.dzu.common.exception.ServiceException;
import org.dzu.common.utils.DateUtils;
import org.dzu.common.utils.SecurityUtils;
import org.dzu.common.utils.StringUtils;
import org.dzu.system.domain.BankAccount;
import org.dzu.system.mapper.OilRechargeMapper;
import org.dzu.system.domain.OilRecharge;
import org.dzu.system.service.IBankAccountService;
import org.dzu.system.service.IOilRechargeService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Isolation;
import org.springframework.transaction.annotation.Transactional;

@Service
public class OilRechargeServiceImpl implements IOilRechargeService {

    @Autowired
    private OilRechargeMapper oilRechargeMapper;

    @Autowired
    private IBankAccountService bankAccountService;

    @Override
    public OilRecharge selectOilRechargeById(Long id) {
        return oilRechargeMapper.selectOilRechargeById(id);
    }

    @Override
    public List<OilRecharge> selectOilRechargeList(OilRecharge oilRecharge) {
        return oilRechargeMapper.selectOilRechargeList(oilRecharge);
    }

    @Override
    @Transactional(isolation = Isolation.SERIALIZABLE, rollbackFor = Exception.class)
    public int insertOilRecharge(OilRecharge oilRecharge) {
        // 校验逻辑
        validate(oilRecharge);

        // 验证银行卡号是否存在
        if (OilRechargeConstant.BankCord.equals(oilRecharge.getRechargeType())) {
            BankAccount bankAccount = bankAccountService.selectBankAccountByBankNo(oilRecharge.getBankNo());
            if (bankAccount == null) {
                throw new RuntimeException("银行卡号不存在");
            }
        }

        oilRecharge.setAddtime(String.valueOf(DateUtils.getNowDate()));
        oilRecharge.setUserId(SecurityUtils.getUserId());
        oilRecharge.setUserName(SecurityUtils.getUserTruename());
        oilRecharge.setDelFlag(Long.valueOf(DelConstants.NODEL));

        return oilRechargeMapper.insertOilRecharge(oilRecharge);
    }

    private void validate(OilRecharge oilRecharge) {
        if (OilRechargeConstant.BankCord.equals(oilRecharge.getRechargeType()) && StringUtils.isEmpty(oilRecharge.getBankNo())) {
            throw new ServiceException("银行卡必须有银行卡号");
        }
    }

    @Override
    @Transactional(isolation = Isolation.SERIALIZABLE, rollbackFor = Exception.class)
    public int updateOilRecharge(OilRecharge oilRecharge) {
        oilRecharge.setUserId(SecurityUtils.getUserId());
        oilRecharge.setUserName(SecurityUtils.getUserTruename());
        oilRecharge.setUpdateTime(DateUtils.getNowDate());

        // 校验逻辑
        validate(oilRecharge);

        // 验证银行卡号是否存在
        if (OilRechargeConstant.BankCord.equals(oilRecharge.getRechargeType())) {
            BankAccount bankAccount = bankAccountService.selectBankAccountByBankNo(oilRecharge.getBankNo());
            if (bankAccount == null) {
                throw new RuntimeException("银行卡号不存在");
            }
        }

        // 检查是否存在相同的卡号
        List<OilRecharge> oilRecharges = selectOilRechargeList(oilRecharge);
        if (!oilRecharges.isEmpty()) {
            throw new ServiceException("存在相同的银行卡号！请删除原有的或更改本次的");
        }

        return oilRechargeMapper.updateOilRecharge(oilRecharge);
    }

    @Override
    public int deleteOilRechargeByIds(Long[] ids) {
        return oilRechargeMapper.deleteOilRechargeByIds(ids);
    }

    @Override
    public int deleteOilRechargeById(Long id) {
        return oilRechargeMapper.deleteOilRechargeById(id);
    }
}
