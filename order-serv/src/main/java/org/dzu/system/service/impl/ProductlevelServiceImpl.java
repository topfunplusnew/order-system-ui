package org.dzu.system.service.impl;

import java.util.List;
import org.dzu.common.utils.DateUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.dzu.system.mapper.ProductlevelMapper;
import org.dzu.system.domain.Productlevel;
import org.dzu.system.service.IProductlevelService;

/**
 * 产品级别管理Service业务层处理
 * 
 * @author ml
 * @date 2024-07-19
 */
@Service
public class ProductlevelServiceImpl implements IProductlevelService 
{
    @Autowired
    private ProductlevelMapper productlevelMapper;

    /**
     * 查询产品级别管理
     * 
     * @param id 产品级别管理主键
     * @return 产品级别管理
     */
    @Override
    public Productlevel selectProductlevelById(Long id)
    {
        return productlevelMapper.selectProductlevelById(id);
    }

    /**
     * 查询产品级别管理列表
     * 
     * @param productlevel 产品级别管理
     * @return 产品级别管理
     */
    @Override
    public List<Productlevel> selectProductlevelList(Productlevel productlevel)
    {
        return productlevelMapper.selectProductlevelList(productlevel);
    }

    /**
     * 新增产品级别管理
     * 
     * @param productlevel 产品级别管理
     * @return 结果
     */
    @Override
    public int insertProductlevel(Productlevel productlevel)
    {
        return productlevelMapper.insertProductlevel(productlevel);
    }

    /**
     * 修改产品级别管理
     * 
     * @param productlevel 产品级别管理
     * @return 结果
     */
    @Override
    public int updateProductlevel(Productlevel productlevel)
    {
        productlevel.setUpdateTime(DateUtils.getNowDate());
        return productlevelMapper.updateProductlevel(productlevel);
    }

    /**
     * 批量删除产品级别管理
     * 
     * @param ids 需要删除的产品级别管理主键
     * @return 结果
     */
    @Override
    public int deleteProductlevelByIds(Long[] ids)
    {
        return productlevelMapper.deleteProductlevelByIds(ids);
    }

    /**
     * 删除产品级别管理信息
     * 
     * @param id 产品级别管理主键
     * @return 结果
     */
    @Override
    public int deleteProductlevelById(Long id)
    {
        return productlevelMapper.deleteProductlevelById(id);
    }
}
