package com.ruoyi.system.mapper;

import java.util.List;
import com.ruoyi.system.domain.Productlevel;

/**
 * 产品级别信息Mapper接口
 * 
 * @author ruoyi
 * @date 2024-07-18
 */
public interface ProductlevelMapper 
{
    /**
     * 查询产品级别信息
     * 
     * @param id 产品级别信息主键
     * @return 产品级别信息
     */
    public Productlevel selectProductlevelById(Long id);

    /**
     * 查询产品级别信息列表
     * 
     * @param productlevel 产品级别信息
     * @return 产品级别信息集合
     */
    public List<Productlevel> selectProductlevelList(Productlevel productlevel);

    /**
     * 新增产品级别信息
     * 
     * @param productlevel 产品级别信息
     * @return 结果
     */
    public int insertProductlevel(Productlevel productlevel);

    /**
     * 修改产品级别信息
     * 
     * @param productlevel 产品级别信息
     * @return 结果
     */
    public int updateProductlevel(Productlevel productlevel);

    /**
     * 删除产品级别信息
     * 
     * @param id 产品级别信息主键
     * @return 结果
     */
    public int deleteProductlevelById(Long id);

    /**
     * 批量删除产品级别信息
     * 
     * @param ids 需要删除的数据主键集合
     * @return 结果
     */
    public int deleteProductlevelByIds(Long[] ids);
}
