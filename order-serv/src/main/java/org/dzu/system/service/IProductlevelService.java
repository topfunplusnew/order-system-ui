package org.dzu.system.service;

import java.util.List;
import org.dzu.system.domain.Productlevel;

/**
 * 产品级别管理Service接口
 * 
 * @author ml
 * @date 2024-07-19
 */
public interface IProductlevelService 
{
    /**
     * 查询产品级别管理
     * 
     * @param id 产品级别管理主键
     * @return 产品级别管理
     */
    public Productlevel selectProductlevelById(Long id);

    /**
     * 查询产品级别管理列表
     * 
     * @param productlevel 产品级别管理
     * @return 产品级别管理集合
     */
    public List<Productlevel> selectProductlevelList(Productlevel productlevel);

    /**
     * 新增产品级别管理
     * 
     * @param productlevel 产品级别管理
     * @return 结果
     */
    public int insertProductlevel(Productlevel productlevel);

    /**
     * 修改产品级别管理
     * 
     * @param productlevel 产品级别管理
     * @return 结果
     */
    public int updateProductlevel(Productlevel productlevel);

    /**
     * 批量删除产品级别管理
     * 
     * @param ids 需要删除的产品级别管理主键集合
     * @return 结果
     */
    public int deleteProductlevelByIds(Long[] ids);

    /**
     * 删除产品级别管理信息
     * 
     * @param id 产品级别管理主键
     * @return 结果
     */
    public int deleteProductlevelById(Long id);
}
