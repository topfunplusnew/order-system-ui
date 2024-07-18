package org.dzu.system.service.impl;

import org.dzu.common.utils.DateUtils;
import org.dzu.system.domain.Productlevel;
import org.dzu.system.mapper.ProductlevelMapper;
import org.dzu.system.service.IProductlevelService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * 产品级别信息Service业务层处理
 * 
 * @author ml
 * @date 2024-07-18
 */
@Service
public class ProductlevelServiceImpl implements IProductlevelService 
{
    @Autowired
    private ProductlevelMapper productlevelMapper;

    /**
     * 查询产品级别信息
     * 
     * @param id 产品级别信息主键
     * @return 产品级别信息
     */
    @Override
    public Productlevel selectProductlevelById(Long id)
    {
        return productlevelMapper.selectProductlevelById(id);
    }

    /**
     * 查询产品级别信息列表
     * 
     * @param productlevel 产品级别信息
     * @return 产品级别信息
     */
    @Override
    public List<Productlevel> selectProductlevelList(Productlevel productlevel)
    {
        return productlevelMapper.selectProductlevelList(productlevel);
    }

    /**
     * 新增产品级别信息
     * 
     * @param productlevel 产品级别信息
     * @return 结果
     */
    @Override
    public int insertProductlevel(Productlevel productlevel)
    {
        return productlevelMapper.insertProductlevel(productlevel);
    }

    /**
     * 修改产品级别信息
     * 
     * @param productlevel 产品级别信息
     * @return 结果
     */
    @Override
    public int updateProductlevel(Productlevel productlevel)
    {
        productlevel.setUpdateTime(DateUtils.getNowDate());
        return productlevelMapper.updateProductlevel(productlevel);
    }

    /**
     * 批量删除产品级别信息
     * 
     * @param ids 需要删除的产品级别信息主键
     * @return 结果
     */
    @Override
    public int deleteProductlevelByIds(Long[] ids)
    {
        return productlevelMapper.deleteProductlevelByIds(ids);
    }

    /**
     * 删除产品级别信息信息
     * 
     * @param id 产品级别信息主键
     * @return 结果
     */
    @Override
    public int deleteProductlevelById(Long id)
    {
        return productlevelMapper.deleteProductlevelById(id);
    }
}
