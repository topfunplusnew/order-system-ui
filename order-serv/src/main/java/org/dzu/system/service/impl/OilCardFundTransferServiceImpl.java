package org.dzu.system.service.impl;

import java.util.List;

import org.dzu.common.exception.ServiceException;
import org.dzu.common.utils.DateUtils;
import org.dzu.common.utils.SecurityUtils;
import org.dzu.system.domain.OilCard;
import org.dzu.system.mapper.OilCardMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.dzu.system.mapper.OilCardFundTransferMapper;
import org.dzu.system.domain.OilCardFundTransfer;
import org.dzu.system.service.IOilCardFundTransferService;
 
import org.dzu.common.constant.DelConstants;
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
    public void validateMainCardBalance(OilCardFundTransfer oilCardFundTransfer) {
        Long cardNo;
        OilCard oilCard=new OilCard();
        if ("主卡".equals(oilCard.getOilType())) {
            cardNo = Long.valueOf(oilCard.getOilCardNo());
        } else if ("副卡".equals(oilCard.getOilType())) {
            cardNo = Long.valueOf(oilCard.getOilCardNo());
        } else {
            throw new IllegalArgumentException("油卡类型不正确");
        }

        // 获取主卡余额
        Double mainmoney= oilCardFundTransferMapper.getMainCardBalance(cardNo);

        // 检查主卡余额是否大于圈存充值余额
        if (mainmoney == null || mainmoney < oilCardFundTransfer.getRechargeMoney()) {
            throw new IllegalArgumentException("主卡余额不足，无法进行圈存操作");
        }
    }
    /**
     * 新增加油卡圈存
     *
     * @param oilCardFundTransfer 加油卡圈存
     * @return 结果
     */
    @Override
    public int insertOilCardFundTransfer(OilCardFundTransfer oilCardFundTransfer)
    {
        // 保存圈存信息
        int result = oilCardFundTransferMapper.insertOilCardFundTransfer(oilCardFundTransfer);

        // 更新主卡和副卡的当前值
        OilCard mainCard = oilCardMapper.selectOilCardById(oilCardFundTransfer.getOilMainCardNo());
        OilCard secondCard = oilCardMapper.selectOilCardById(oilCardFundTransfer.getOilSecondCardNo());

        if (mainCard != null && secondCard != null) {
            mainCard.setMoneyAmount(oilCardFundTransfer.getRechargeMoney()-mainCard.getMoneyAmount() );
            secondCard.setMoneyAmount(secondCard.getMoneyAmount() + oilCardFundTransfer.getRechargeMoney());
            oilCardMapper.updateOilCard(mainCard);
            oilCardMapper.updateOilCard(secondCard);
        } else {
            throw new ServiceException("主卡或副卡信息不存在");
        }

        oilCardFundTransfer.setAddtime(String.valueOf(DateUtils.getNowDate()));
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
    public int updateOilCardFundTransfer(OilCardFundTransfer oilCardFundTransfer)
    {
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
