package com.ruoyi.system.mapper;

import java.util.List;
import com.ruoyi.system.domain.Oilcard;

/**
 * 加油卡信息Mapper接口
 * 
 * @author ruoyi
 * @date 2024-07-18
 */
public interface OilcardMapper 
{
    /**
     * 查询加油卡信息
     * 
     * @param id 加油卡信息主键
     * @return 加油卡信息
     */
    public Oilcard selectOilcardById(Long id);

    /**
     * 查询加油卡信息列表
     * 
     * @param oilcard 加油卡信息
     * @return 加油卡信息集合
     */
    public List<Oilcard> selectOilcardList(Oilcard oilcard);

    /**
     * 新增加油卡信息
     * 
     * @param oilcard 加油卡信息
     * @return 结果
     */
    public int insertOilcard(Oilcard oilcard);

    /**
     * 修改加油卡信息
     * 
     * @param oilcard 加油卡信息
     * @return 结果
     */
    public int updateOilcard(Oilcard oilcard);

    /**
     * 删除加油卡信息
     * 
     * @param id 加油卡信息主键
     * @return 结果
     */
    public int deleteOilcardById(Long id);

    /**
     * 批量删除加油卡信息
     * 
     * @param ids 需要删除的数据主键集合
     * @return 结果
     */
    public int deleteOilcardByIds(Long[] ids);
}
