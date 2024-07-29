package org.dzu.system.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import java.util.List;
import org.dzu.system.domain.Storehouse;

/**
 * 仓库管理Mapper接口
 * 
 * @author ml
 * @date 2024-07-29
 */
public interface StorehouseMapper extends BaseMapper<Storehouse>
{
    /**
     * 查询仓库管理
     * 
     * @param id 仓库管理主键
     * @return 仓库管理
     */
    public Storehouse selectStorehouseById(Long id);

    /**
     * 查询仓库管理列表
     * 
     * @param storehouse 仓库管理
     * @return 仓库管理集合
     */
    public List<Storehouse> selectStorehouseList(Storehouse storehouse);

    /**
     * 新增仓库管理
     * 
     * @param storehouse 仓库管理
     * @return 结果
     */
    public int insertStorehouse(Storehouse storehouse);

    /**
     * 修改仓库管理
     * 
     * @param storehouse 仓库管理
     * @return 结果
     */
    public int updateStorehouse(Storehouse storehouse);

    /**
     * 删除仓库管理
     * 
     * @param id 仓库管理主键
     * @return 结果
     */
    public int deleteStorehouseById(Long id);

    /**
     * 批量删除仓库管理
     * 
     * @param ids 需要删除的数据主键集合
     * @return 结果
     */
    public int deleteStorehouseByIds(Long[] ids);
}
