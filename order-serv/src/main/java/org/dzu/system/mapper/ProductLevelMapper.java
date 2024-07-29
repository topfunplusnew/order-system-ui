package org.dzu.system.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import java.util.List;
import org.dzu.system.domain.ProductLevel;

/**
 * 产品级别Mapper接口
 * 
 * @author ml
 * @date 2024-07-29
 */
public interface ProductLevelMapper extends BaseMapper<ProductLevel>
{
    /**
     * 查询产品级别
     * 
     * @param id 产品级别主键
     * @return 产品级别
     */
    public ProductLevel selectProductLevelById(Long id);

    /**
     * 查询产品级别列表
     * 
     * @param productLevel 产品级别
     * @return 产品级别集合
     */
    public List<ProductLevel> selectProductLevelList(ProductLevel productLevel);

    /**
     * 新增产品级别
     * 
     * @param productLevel 产品级别
     * @return 结果
     */
    public int insertProductLevel(ProductLevel productLevel);

    /**
     * 修改产品级别
     * 
     * @param productLevel 产品级别
     * @return 结果
     */
    public int updateProductLevel(ProductLevel productLevel);

    /**
     * 删除产品级别
     * 
     * @param id 产品级别主键
     * @return 结果
     */
    public int deleteProductLevelById(Long id);

    /**
     * 批量删除产品级别
     * 
     * @param ids 需要删除的数据主键集合
     * @return 结果
     */
    public int deleteProductLevelByIds(Long[] ids);
}
