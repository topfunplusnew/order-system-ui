package org.dzu.system.service.impl;

import org.dzu.common.constant.DelConstants;
import org.dzu.common.constant.OilRechargeConstant;
import org.dzu.common.exception.ServiceException;
import org.dzu.common.utils.DateUtils;
import org.dzu.common.utils.SecurityUtils;
import org.dzu.common.utils.StringUtils;
import org.dzu.system.domain.BankAccount;
import org.dzu.system.domain.OilCardFundTransfer;
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
    }  private void validate(OilRecharge oilRecharge) {
        if (OilRechargeConstant.BankCord.equals(oilRecharge.getRechargeType()) && StringUtils.isEmpty(oilRecharge.getBankNo())) {
            throw new ServiceException("银行卡必须有银行卡号");
        }
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

        // 校验逻辑
        validate(oilRecharge);

        // 验证银行卡号是否存在
        if (OilRechargeConstant.BankCord.equals(oilRecharge.getRechargeType())) {
            BankAccount bankAccount = bankAccountService.selectBankAccountByBankNo(oilRecharge.getBankNo());
            if (bankAccount == null) {
                throw new RuntimeException("银行卡号不存在");
            }
        }

        // 检查银行卡余额是否足够
        BankAccount bankAccount=new BankAccount();
        Double currentBalance = bankAccount.getAmount();
        if (currentBalance < oilRecharge.getRechargeMoney()) {
            throw new RuntimeException("银行卡余额不足");
        }

        oilRecharge.setAddtime(String.valueOf(DateUtils.getNowDate()));
        oilRecharge.setUserId(SecurityUtils.getUserId());
        oilRecharge.setUserName(SecurityUtils.getUserTruename());
        oilRecharge.setDelFlag(Long.valueOf(DelConstants.NODEL));

        return oilRechargeMapper.insertOilRecharge(oilRecharge);
    }
    @Override
    public void calculateCardBalances(OilRecharge oilRecharge) {
        // 获取主卡卡号
        OilCardFundTransfer oilCardFundTransfer = new OilCardFundTransfer();
        String mainoilCardNo = String.valueOf(oilCardFundTransfer.getOilMainCardNo());

        // 获取副卡卡号
        String secondoilCardNo = String.valueOf(oilCardFundTransfer.getOilSecondCardNo());

        // 获取主卡消费金额总和
        Double mainCardTotalSpent = oilCardConsumeMapper.getrefuelingMoney(mainoilCardNo);

        // 获取副卡消费金额总和
        Double secondCardTotalSpent =oilCardConsumeMapper.getrefuelingMoney(secondoilCardNo);

        // 获取圈存副卡金额
        Double secondCardRechargeAmount = oilRecharge.getRechargeMoney(); // 圈存金额是充值到副卡的金额
        // 获取主卡当前金额
        Double mainCardmoneyAmount = oilCardMapper.getmoneyAmount(mainoilCardNo);
        Double newMainOilCardmoneyAmount = mainCardmoneyAmount - mainCardTotalSpent - secondCardRechargeAmount;

        // 获取副卡当前金额
        Double secondmoneyAmount = oilCardMapper.getmoneyAmount(secondoilCardNo);
        Double newSecondOilCardmoneyAmount = secondCardRechargeAmount - secondCardTotalSpent;

        // 更新主卡和副卡余额
        oilCardMapper.updatemoneyAmount(mainoilCardNo, newMainOilCardmoneyAmount);
        oilCardMapper.updatemoneyAmount(secondoilCardNo, newSecondOilCardmoneyAmount);
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
        // 检查银行卡余额是否足够
        BankAccount bankAccount=new BankAccount();
        Double currentBalance = bankAccount.getAmount();
        if (currentBalance < oilRecharge.getRechargeMoney()) {
            throw new RuntimeException("银行卡余额不足");
        }

        // 检查是否存在相同的卡号
        List<OilRecharge> oilRecharges = selectOilRechargeList(oilRecharge);
        if (!oilRecharges.isEmpty()) {
            throw new ServiceException("存在相同的银行卡号！请删除原有的或更改本次的");
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
    public int deleteOilRechargeByIds(Long[] ids) {
        return oilRechargeMapper.deleteOilRechargeByIds(ids);
    }

    /**
     * 删除加油卡充值信息信息
     *
     * @param id 加油卡充值信息主键
     * @return 结果
     */
    @Override
    public int deleteOilRechargeById(Long id) {
        return oilRechargeMapper.deleteOilRechargeById(id);
    }
}
