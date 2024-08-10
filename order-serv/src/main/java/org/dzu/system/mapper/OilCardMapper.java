package org.dzu.system.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import org.dzu.system.domain.OilCard;

import java.util.List;

/**
 * 加油卡信息Mapper接口
 * 
 * @author ml
 * @date 2024-07-29
 */
public interface OilCardMapper extends BaseMapper<OilCard>
{
    /**
     * 查询加油卡信息
     * 
     * @param id 加油卡信息主键
     * @return 加油卡信息
     */
    public OilCard selectOilCardById(Long id);

    /**
     * 查询加油卡信息列表
     * 
     * @param oilCard 加油卡信息
     * @return 加油卡信息集合
     */
    public List<OilCard> selectOilCardList(OilCard oilCard);

    /**
     * 新增加油卡信息
     * 
     * @param oilCard 加油卡信息
     * @return 结果
     */
    public int insertOilCard(OilCard oilCard);

    /**
     * 修改加油卡信息
     * 
     * @param oilCard 加油卡信息
     * @return 结果
     */
    public int updateOilCard(OilCard oilCard);

    /**
     * 删除加油卡信息
     * 
     * @param id 加油卡信息主键
     * @return 结果
     */
    public int deleteOilCardById(Long id);

    /**
     * 批量删除加油卡信息
     * 
     * @param ids 需要删除的数据主键集合
     * @return 结果
     */
    public int deleteOilCardByIds(Long[] ids);
    /**
     * 获取消费金额
     *
     * @param oilCardNo 加油卡卡号
     * @return 加油卡当前余额
     */
    public  Double getmoneyAmount(String oilCardNo);
    /**
     * 更新加油卡当前余额
     *
     * @param oilCardNo&&moneyAmount  加油卡卡号
     * @return 加油卡当前余额
     */
    public  void updatemoneyAmount(String oilCardNo, Double moneyAmount);
    /**
     * 获取主卡余额
     *
     * @param oilCardNo 加��卡卡号
     * @return 主卡余额
     */
    public OilCard selectOilCardByoilCardNo(String oilCardNo);

}
