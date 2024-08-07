package org.dzu.system.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import org.dzu.system.domain.OilCardFundTransfer;

import java.util.List;

/**
 * 加油卡圈存Mapper接口
 * 
 * @author ml
 * @date 2024-07-29
 */
public interface OilCardFundTransferMapper extends BaseMapper<OilCardFundTransfer>
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
     * 获取主卡余额
     *
     * @param oilCardNo 加油卡卡号
     * @return 主卡余额
     */
    Double getMainCardBalance(Long oilCardNo);
    /**
     * 修改加油卡圈存
     * 
     * @param oilCardFundTransfer 加油卡圈存
     * @return 结果
     */
    public int updateOilCardFundTransfer(OilCardFundTransfer oilCardFundTransfer);

    /**
     * 删除加油卡圈存
     * 
     * @param id 加油卡圈存主键
     * @return 结果
     */
    public int deleteOilCardFundTransferById(Long id);

    /**
     * 批量删除加油卡圈存
     * 
     * @param ids 需要删除的数据主键集合
     * @return 结果
     */
    public int deleteOilCardFundTransferByIds(Long[] ids);
}
