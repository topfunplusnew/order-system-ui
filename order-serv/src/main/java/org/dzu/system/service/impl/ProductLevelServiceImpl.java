package org.dzu.system.service.impl;

import java.util.List;
import org.dzu.common.utils.DateUtils;
import org.dzu.common.utils.SecurityUtils;
import org.dzu.common.utils.SecurityUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.dzu.system.mapper.ProductLevelMapper;
import org.dzu.system.domain.ProductLevel;
import org.dzu.system.service.IProductLevelService;
 
import org.dzu.common.constant.DelConstants;
/**
 * 产品级别Service业务层处理
 *
 * @author ml
 * @date 2024-07-29
 */
@Service
public class ProductLevelServiceImpl implements IProductLevelService
{
    @Autowired
    private ProductLevelMapper productLevelMapper;

    /**
     * 查询产品级别
     *
     * @param id 产品级别主键
     * @return 产品级别
     */
    @Override
    public ProductLevel selectProductLevelById(Long id)
    {
        return productLevelMapper.selectProductLevelById(id);
    }

    /**
     * 查询产品级别列表
     *
     * @param productLevel 产品级别
     * @return 产品级别
     */
    @Override
    public List<ProductLevel> selectProductLevelList(ProductLevel productLevel)
    {
        return productLevelMapper.selectProductLevelList(productLevel);
    }

    /**
     * 新增产品级别
     *
     * @param productLevel 产品级别
     * @return 结果
     */
    @Override
    public int insertProductLevel(ProductLevel productLevel)
    {
        productLevel.setAddtime(String.valueOf(DateUtils.getNowDate()));
        productLevel.setUserId(SecurityUtils.getUserId());
        productLevel.setUserName(SecurityUtils.getUserTruename());
        productLevel.setDelFlag(Long.valueOf(DelConstants.NODEL));
        return productLevelMapper.insertProductLevel(productLevel);
    }

    /**
     * 修改产品级别
     * 
     * @param productLevel 产品级别
     * @return 结果
     */
    @Override
    public int updateProductLevel(ProductLevel productLevel)
    {
        productLevel.setUserId(SecurityUtils.getUserId());
        productLevel.setUserName(SecurityUtils.getUserTruename());
        productLevel.setUpdateTime(DateUtils.getNowDate());
        return productLevelMapper.updateProductLevel(productLevel);
    }

    /**
     * 批量删除产品级别
     * 
     * @param ids 需要删除的产品级别主键
     * @return 结果
     */
    @Override
    public int deleteProductLevelByIds(Long[] ids)
    {
        return productLevelMapper.deleteProductLevelByIds(ids);
    }

    /**
     * 删除产品级别信息
     * 
     * @param id 产品级别主键
     * @return 结果
     */
    @Override
    public int deleteProductLevelById(Long id)
    {
        return productLevelMapper.deleteProductLevelById(id);
    }
}
