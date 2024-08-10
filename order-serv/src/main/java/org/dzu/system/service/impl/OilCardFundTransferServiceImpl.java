package org.dzu.system.service.impl;

import org.dzu.common.constant.DelConstants;
import org.dzu.common.exception.ServiceException;
import org.dzu.common.utils.DateUtils;
import org.dzu.common.utils.SecurityUtils;
import org.dzu.system.domain.OilCard;
import org.dzu.system.domain.OilCardFundTransfer;
import org.dzu.system.mapper.OilCardFundTransferMapper;
import org.dzu.system.mapper.OilCardMapper;
import org.dzu.system.service.IOilCardFundTransferService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
/**
 * 加油卡圈存Service业务层处理
 *
 * @author ml
 * @date 2024-07-29
 */
@Service
public class OilCardFundTransferServiceImpl implements IOilCardFundTransferService
{
    @Autowired
    private OilCardFundTransferMapper oilCardFundTransferMapper;
    @Autowired
    private OilCardMapper oilCardMapper;

    /**
     * 查询加油卡圈存
     *
     * @param id 加油卡圈存主键
     * @return 加油卡圈存
     */
    @Override
    public OilCardFundTransfer selectOilCardFundTransferById(Long id)
    {
        return oilCardFundTransferMapper.selectOilCardFundTransferById(id);
    }

    /**
     * 查询加油卡圈存列表
     *
     * @param oilCardFundTransfer 加油卡圈存
     * @return 加油卡圈存
     */
    @Override
    public List<OilCardFundTransfer> selectOilCardFundTransferList(OilCardFundTransfer oilCardFundTransfer)
    {
        return oilCardFundTransferMapper.selectOilCardFundTransferList(oilCardFundTransfer);
    }

    /**
     * 新增加油卡圈存
     *
     * @param oilCardFundTransfer 加油卡圈存
     * @return 结果
     */
    @Override
    @Transactional
    public int insertOilCardFundTransfer(OilCardFundTransfer oilCardFundTransfer) {
        // 获取主卡和副卡信息
        OilCard mainCard = oilCardMapper.selectOilCardByoilCardNo(oilCardFundTransfer.getOilMainCardNo());
        OilCard secondCard = oilCardMapper.selectOilCardByoilCardNo(oilCardFundTransfer.getOilSecondCardNo());

        if (mainCard == null || secondCard == null) {
            throw new ServiceException("该主卡或者副卡信息不存在");
        }

        // 检查主卡余额是否大于圈存充值余额
        Double mainMoney = mainCard.getMoneyAmount();
        if (mainMoney == null || mainMoney < oilCardFundTransfer.getRechargeMoney()) {
            throw new IllegalArgumentException("主卡余额不足，无法进行圈存操作");
        }

        // 更新主卡和副卡的金额
        mainCard.setMoneyAmount(mainMoney - oilCardFundTransfer.getRechargeMoney());
        secondCard.setMoneyAmount(secondCard.getMoneyAmount() + oilCardFundTransfer.getRechargeMoney());

        // 更新主卡和副卡信息
        oilCardMapper.updateOilCard(mainCard);
        oilCardMapper.updateOilCard(secondCard);

        // 设置其他必要信息
        oilCardFundTransfer.setAddtime(DateUtils.getNowDate().toString());
        oilCardFundTransfer.setUserId(SecurityUtils.getUserId());
        oilCardFundTransfer.setUserName(SecurityUtils.getUserTruename());
        oilCardFundTransfer.setDelFlag(Long.valueOf(DelConstants.NODEL));

        return oilCardFundTransferMapper.insertOilCardFundTransfer(oilCardFundTransfer);
    }

    /**
     * 修改加油卡圈存
     * 
     * @param oilCardFundTransfer 加油卡圈存
     * @return 结果
     */
    @Override
    @Transactional
    public int updateOilCardFundTransfer(OilCardFundTransfer oilCardFundTransfer) {
        // 获取主卡和副卡信息
        OilCard mainCard = oilCardMapper.selectOilCardByoilCardNo(oilCardFundTransfer.getOilMainCardNo());
        OilCard secondCard = oilCardMapper.selectOilCardByoilCardNo(oilCardFundTransfer.getOilSecondCardNo());

        if (mainCard == null || secondCard == null) {
            throw new ServiceException("主卡或副卡信息不存在");
        }

        // 检查主卡余额是否大于圈存充值余额
        Double mainMoney = mainCard.getMoneyAmount();
        if (mainMoney == null || mainMoney < oilCardFundTransfer.getRechargeMoney()) {
            throw new IllegalArgumentException("主卡余额不足，无法进行圈存操作");
        }

        // 更新主卡和副卡的金额
        mainCard.setMoneyAmount(mainMoney - oilCardFundTransfer.getRechargeMoney());
        secondCard.setMoneyAmount(secondCard.getMoneyAmount() + oilCardFundTransfer.getRechargeMoney());

        // 更新主卡和副卡信息
        oilCardMapper.updateOilCard(mainCard);
        oilCardMapper.updateOilCard(secondCard);

        // 更新其他信息
        oilCardFundTransfer.setUserId(SecurityUtils.getUserId());
        oilCardFundTransfer.setUserName(SecurityUtils.getUserTruename());
        oilCardFundTransfer.setUpdateTime(DateUtils.getNowDate());

        return oilCardFundTransferMapper.updateOilCardFundTransfer(oilCardFundTransfer);
    }


    /**
     * 批量删除加油卡圈存
     * 
     * @param ids 需要删除的加油卡圈存主键
     * @return 结果
     */
    @Override
    public int deleteOilCardFundTransferByIds(Long[] ids)
    {
        return oilCardFundTransferMapper.deleteOilCardFundTransferByIds(ids);
    }

    /**
     * 删除加油卡圈存信息
     * 
     * @param id 加油卡圈存主键
     * @return 结果
     */
    @Override
    public int deleteOilCardFundTransferById(Long id)
    {
        return oilCardFundTransferMapper.deleteOilCardFundTransferById(id);
    }
}
