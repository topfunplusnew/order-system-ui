package org.dzu.system.service;

import org.dzu.system.domain.OilCardFundTransfer;

import java.util.List;

/**
 * 加油卡圈存Service接口
 * 
 * @author ml
 * @date 2024-07-29
 */
public interface IOilCardFundTransferService 
{
    /**
     * 查询加油卡圈存
     * 
     * @param id 加油卡圈存主键
     * @return 加油卡圈存
     */
    public OilCardFundTransfer selectOilCardFundTransferById(Long id);

    /**
     * 查询加油卡圈存列表
     * 
     * @param oilCardFundTransfer 加油卡圈存
     * @return 加油卡圈存集合
     */
    public List<OilCardFundTransfer> selectOilCardFundTransferList(OilCardFundTransfer oilCardFundTransfer);

    /**
     * 新增加油卡圈存
     * 
     * @param oilCardFundTransfer 加油卡圈存
     * @return 结果
     */
    public int insertOilCardFundTransfer(OilCardFundTransfer oilCardFundTransfer);

    /**
     * 修改加油卡圈存
     * 
     * @param oilCardFundTransfer 加油卡圈存
     * @return 结果
     */
    public int updateOilCardFundTransfer(OilCardFundTransfer oilCardFundTransfer);

    /**
     * 批量删除加油卡圈存
     * 
     * @param ids 需要删除的加油卡圈存主键集合
     * @return 结果
     */
    public int deleteOilCardFundTransferByIds(Long[] ids);

}
