package com.ruoyi.system.service.impl;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.ruoyi.system.mapper.TableeditmessageMapper;
import com.ruoyi.system.domain.Tableeditmessage;
import com.ruoyi.system.service.ITableeditmessageService;

/**
 * 信息Service业务层处理
 * 
 * @author ruoyi
 * @date 2024-07-18
 */
@Service
public class TableeditmessageServiceImpl implements ITableeditmessageService 
{
    @Autowired
    private TableeditmessageMapper tableeditmessageMapper;

    /**
     * 查询信息
     * 
     * @param id 信息主键
     * @return 信息
     */
    @Override
    public Tableeditmessage selectTableeditmessageById(Long id)
    {
        return tableeditmessageMapper.selectTableeditmessageById(id);
    }

    /**
     * 查询信息列表
     * 
     * @param tableeditmessage 信息
     * @return 信息
     */
    @Override
    public List<Tableeditmessage> selectTableeditmessageList(Tableeditmessage tableeditmessage)
    {
        return tableeditmessageMapper.selectTableeditmessageList(tableeditmessage);
    }

    /**
     * 新增信息
     * 
     * @param tableeditmessage 信息
     * @return 结果
     */
    @Override
    public int insertTableeditmessage(Tableeditmessage tableeditmessage)
    {
        return tableeditmessageMapper.insertTableeditmessage(tableeditmessage);
    }

    /**
     * 修改信息
     * 
     * @param tableeditmessage 信息
     * @return 结果
     */
    @Override
    public int updateTableeditmessage(Tableeditmessage tableeditmessage)
    {
        return tableeditmessageMapper.updateTableeditmessage(tableeditmessage);
    }

    /**
     * 批量删除信息
     * 
     * @param ids 需要删除的信息主键
     * @return 结果
     */
    @Override
    public int deleteTableeditmessageByIds(Long[] ids)
    {
        return tableeditmessageMapper.deleteTableeditmessageByIds(ids);
    }

    /**
     * 删除信息信息
     * 
     * @param id 信息主键
     * @return 结果
     */
    @Override
    public int deleteTableeditmessageById(Long id)
    {
        return tableeditmessageMapper.deleteTableeditmessageById(id);
    }
}
