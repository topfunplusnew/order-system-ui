package org.dzu.system.service.impl;

import java.util.List;
import org.dzu.common.utils.DateUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.dzu.system.mapper.ExwarehouseMapper;
import org.dzu.system.domain.Exwarehouse;
import org.dzu.system.service.IExwarehouseService;

/**
 * 出库信息Service业务层处理
 * 
 * @author ml
 * @date 2024-07-18
 */
@Service
public class ExwarehouseServiceImpl implements IExwarehouseService 
{
    @Autowired
    private ExwarehouseMapper exwarehouseMapper;

    /**
     * 查询出库信息
     * 
     * @param id 出库信息主键
     * @return 出库信息
     */
    @Override
    public Exwarehouse selectExwarehouseById(Long id)
    {
        return exwarehouseMapper.selectExwarehouseById(id);
    }

    /**
     * 查询出库信息列表
     * 
     * @param exwarehouse 出库信息
     * @return 出库信息
     */
    @Override
    public List<Exwarehouse> selectExwarehouseList(Exwarehouse exwarehouse)
    {
        return exwarehouseMapper.selectExwarehouseList(exwarehouse);
    }

    /**
     * 新增出库信息
     * 
     * @param exwarehouse 出库信息
     * @return 结果
     */
    @Override
    public int insertExwarehouse(Exwarehouse exwarehouse)
    {
        return exwarehouseMapper.insertExwarehouse(exwarehouse);
    }

    /**
     * 修改出库信息
     * 
     * @param exwarehouse 出库信息
     * @return 结果
     */
    @Override
    public int updateExwarehouse(Exwarehouse exwarehouse)
    {
        exwarehouse.setUpdateTime(DateUtils.getNowDate());
        return exwarehouseMapper.updateExwarehouse(exwarehouse);
    }

    /**
     * 批量删除出库信息
     * 
     * @param ids 需要删除的出库信息主键
     * @return 结果
     */
    @Override
    public int deleteExwarehouseByIds(Long[] ids)
    {
        return exwarehouseMapper.deleteExwarehouseByIds(ids);
    }

    /**
     * 删除出库信息信息
     * 
     * @param id 出库信息主键
     * @return 结果
     */
    @Override
    public int deleteExwarehouseById(Long id)
    {
        return exwarehouseMapper.deleteExwarehouseById(id);
    }
}
