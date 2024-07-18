package org.dzu.system.service.impl;

import java.util.List;
import org.dzu.common.utils.DateUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.dzu.system.mapper.BusinesstripMapper;
import org.dzu.system.domain.Businesstrip;
import org.dzu.system.service.IBusinesstripService;

/**
 * 出差记录Service业务层处理
 * 
 * @author ml
 * @date 2024-07-18
 */
@Service
public class BusinesstripServiceImpl implements IBusinesstripService 
{
    @Autowired
    private BusinesstripMapper businesstripMapper;

    /**
     * 查询出差记录
     * 
     * @param id 出差记录主键
     * @return 出差记录
     */
    @Override
    public Businesstrip selectBusinesstripById(Long id)
    {
        return businesstripMapper.selectBusinesstripById(id);
    }

    /**
     * 查询出差记录列表
     * 
     * @param businesstrip 出差记录
     * @return 出差记录
     */
    @Override
    public List<Businesstrip> selectBusinesstripList(Businesstrip businesstrip)
    {
        return businesstripMapper.selectBusinesstripList(businesstrip);
    }

    /**
     * 新增出差记录
     * 
     * @param businesstrip 出差记录
     * @return 结果
     */
    @Override
    public int insertBusinesstrip(Businesstrip businesstrip)
    {
        return businesstripMapper.insertBusinesstrip(businesstrip);
    }

    /**
     * 修改出差记录
     * 
     * @param businesstrip 出差记录
     * @return 结果
     */
    @Override
    public int updateBusinesstrip(Businesstrip businesstrip)
    {
        businesstrip.setUpdateTime(DateUtils.getNowDate());
        return businesstripMapper.updateBusinesstrip(businesstrip);
    }

    /**
     * 批量删除出差记录
     * 
     * @param ids 需要删除的出差记录主键
     * @return 结果
     */
    @Override
    public int deleteBusinesstripByIds(Long[] ids)
    {
        return businesstripMapper.deleteBusinesstripByIds(ids);
    }

    /**
     * 删除出差记录信息
     * 
     * @param id 出差记录主键
     * @return 结果
     */
    @Override
    public int deleteBusinesstripById(Long id)
    {
        return businesstripMapper.deleteBusinesstripById(id);
    }
}
