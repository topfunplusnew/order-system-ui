package org.dzu.system.service.impl;

import java.util.List;
import org.dzu.common.utils.DateUtils;
import org.dzu.common.utils.SecurityUtils;
import org.dzu.common.utils.SecurityUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.dzu.system.mapper.TableeditmessageMapper;
import org.dzu.system.domain.Tableeditmessage;
import org.dzu.system.service.ITableeditmessageService;
/**
 * 变动日志信息Service业务层处理
 *
 * @author ml
 * @date 2024-07-29
 */
@Service
public class TableeditmessageServiceImpl implements ITableeditmessageService
{
    @Autowired
    private TableeditmessageMapper tableeditmessageMapper;

    /**
     * 查询变动日志信息
     *
     * @param id 变动日志信息主键
     * @return 变动日志信息
     */
    @Override
    public Tableeditmessage selectTableeditmessageById(Long id)
    {
        return tableeditmessageMapper.selectTableeditmessageById(id);
    }

    /**
     * 查询变动日志信息列表
     *
     * @param tableeditmessage 变动日志信息
     * @return 变动日志信息
     */
    @Override
    public List<Tableeditmessage> selectTableeditmessageList(Tableeditmessage tableeditmessage)
    {
        return tableeditmessageMapper.selectTableeditmessageList(tableeditmessage);
    }

    /**
     * 新增变动日志信息
     *
     * @param tableeditmessage 变动日志信息
     * @return 结果
     */
    @Override
    public int insertTableeditmessage(Tableeditmessage tableeditmessage)
    {
        tableeditmessage.setAddtime(String.valueOf(DateUtils.getNowDate()));
        tableeditmessage.setUserId(SecurityUtils.getUserId());
        tableeditmessage.setUserName(SecurityUtils.getUserTruename());
        return tableeditmessageMapper.insertTableeditmessage(tableeditmessage);
    }

    /**
     * 修改变动日志信息
     * 
     * @param tableeditmessage 变动日志信息
     * @return 结果
     */
    @Override
    public int updateTableeditmessage(Tableeditmessage tableeditmessage)
    {
        tableeditmessage.setUserId(SecurityUtils.getUserId());
        tableeditmessage.setUserName(SecurityUtils.getUserTruename());
        return tableeditmessageMapper.updateTableeditmessage(tableeditmessage);
    }

    /**
     * 批量删除变动日志信息
     * 
     * @param ids 需要删除的变动日志信息主键
     * @return 结果
     */
    @Override
    public int deleteTableeditmessageByIds(Long[] ids)
    {
        return tableeditmessageMapper.deleteTableeditmessageByIds(ids);
    }

    /**
     * 删除变动日志信息信息
     * 
     * @param id 变动日志信息主键
     * @return 结果
     */
    @Override
    public int deleteTableeditmessageById(Long id)
    {
        return tableeditmessageMapper.deleteTableeditmessageById(id);
    }
}
