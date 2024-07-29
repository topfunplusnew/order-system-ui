package org.dzu.system.service.impl;

import java.util.List;
import org.dzu.common.utils.DateUtils;
import org.dzu.common.utils.SecurityUtils;
import org.dzu.common.utils.SecurityUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.dzu.system.mapper.BusinesstripMapper;
import org.dzu.system.domain.Businesstrip;
import org.dzu.system.service.IBusinesstripService;
 
import org.dzu.common.constant.DelConstants;
/**
 * 出差登记Service业务层处理
 *
 * @author ml
 * @date 2024-07-29
 */
@Service
public class BusinesstripServiceImpl implements IBusinesstripService
{
    @Autowired
    private BusinesstripMapper businesstripMapper;

    /**
     * 查询出差登记
     *
     * @param id 出差登记主键
     * @return 出差登记
     */
    @Override
    public Businesstrip selectBusinesstripById(Long id)
    {
        return businesstripMapper.selectBusinesstripById(id);
    }

    /**
     * 查询出差登记列表
     *
     * @param businesstrip 出差登记
     * @return 出差登记
     */
    @Override
    public List<Businesstrip> selectBusinesstripList(Businesstrip businesstrip)
    {
        return businesstripMapper.selectBusinesstripList(businesstrip);
    }

    /**
     * 新增出差登记
     *
     * @param businesstrip 出差登记
     * @return 结果
     */
    @Override
    public int insertBusinesstrip(Businesstrip businesstrip)
    {
        businesstrip.setAddtime(String.valueOf(DateUtils.getNowDate()));
        businesstrip.setUserId(SecurityUtils.getUserId());
        businesstrip.setUserName(SecurityUtils.getUserTruename());
        businesstrip.setDelFlag(Long.valueOf(DelConstants.NODEL));
        return businesstripMapper.insertBusinesstrip(businesstrip);
    }

    /**
     * 修改出差登记
     * 
     * @param businesstrip 出差登记
     * @return 结果
     */
    @Override
    public int updateBusinesstrip(Businesstrip businesstrip)
    {
        businesstrip.setUserId(SecurityUtils.getUserId());
        businesstrip.setUserName(SecurityUtils.getUserTruename());
        businesstrip.setUpdateTime(DateUtils.getNowDate());
        return businesstripMapper.updateBusinesstrip(businesstrip);
    }

    /**
     * 批量删除出差登记
     * 
     * @param ids 需要删除的出差登记主键
     * @return 结果
     */
    @Override
    public int deleteBusinesstripByIds(Long[] ids)
    {
        return businesstripMapper.deleteBusinesstripByIds(ids);
    }

    /**
     * 删除出差登记信息
     * 
     * @param id 出差登记主键
     * @return 结果
     */
    @Override
    public int deleteBusinesstripById(Long id)
    {
        return businesstripMapper.deleteBusinesstripById(id);
    }
}
