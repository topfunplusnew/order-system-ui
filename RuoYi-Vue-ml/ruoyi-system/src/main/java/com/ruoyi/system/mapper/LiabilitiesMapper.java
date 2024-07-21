package com.ruoyi.system.mapper;

import java.util.List;
import com.ruoyi.system.domain.Liabilities;

/**
 * 负债信息Mapper接口
 * 
 * @author ruoyi
 * @date 2024-07-18
 */
public interface LiabilitiesMapper 
{
    /**
     * 查询负债信息
     * 
     * @param id 负债信息主键
     * @return 负债信息
     */
    public Liabilities selectLiabilitiesById(Long id);

    /**
     * 查询负债信息列表
     * 
     * @param liabilities 负债信息
     * @return 负债信息集合
     */
    public List<Liabilities> selectLiabilitiesList(Liabilities liabilities);

    /**
     * 新增负债信息
     * 
     * @param liabilities 负债信息
     * @return 结果
     */
    public int insertLiabilities(Liabilities liabilities);

    /**
     * 修改负债信息
     * 
     * @param liabilities 负债信息
     * @return 结果
     */
    public int updateLiabilities(Liabilities liabilities);

    /**
     * 删除负债信息
     * 
     * @param id 负债信息主键
     * @return 结果
     */
    public int deleteLiabilitiesById(Long id);

    /**
     * 批量删除负债信息
     * 
     * @param ids 需要删除的数据主键集合
     * @return 结果
     */
    public int deleteLiabilitiesByIds(Long[] ids);
}
