package org.dzu.system.mapper;

import java.util.List;
import org.dzu.system.domain.Oilcard;

/**
 * 加油卡Mapper接口
 * 
 * @author ml
 * @date 2024-07-19
 */
public interface OilcardMapper 
{
    /**
     * 查询加油卡
     * 
     * @param id 加油卡主键
     * @return 加油卡
     */
    public Oilcard selectOilcardById(Long id);

    /**
     * 查询加油卡列表
     * 
     * @param oilcard 加油卡
     * @return 加油卡集合
     */
    public List<Oilcard> selectOilcardList(Oilcard oilcard);

    /**
     * 新增加油卡
     * 
     * @param oilcard 加油卡
     * @return 结果
     */
    public int insertOilcard(Oilcard oilcard);

    /**
     * 修改加油卡
     * 
     * @param oilcard 加油卡
     * @return 结果
     */
    public int updateOilcard(Oilcard oilcard);

    /**
     * 删除加油卡
     * 
     * @param id 加油卡主键
     * @return 结果
     */
    public int deleteOilcardById(Long id);

    /**
     * 批量删除加油卡
     * 
     * @param ids 需要删除的数据主键集合
     * @return 结果
     */
    public int deleteOilcardByIds(Long[] ids);
}
