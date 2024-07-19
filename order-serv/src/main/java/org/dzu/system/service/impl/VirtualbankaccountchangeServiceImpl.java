package org.dzu.system.service.impl;

import java.util.List;
import org.dzu.common.utils.DateUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.dzu.system.mapper.VirtualbankaccountchangeMapper;
import org.dzu.system.domain.Virtualbankaccountchange;
import org.dzu.system.service.IVirtualbankaccountchangeService;

/**
 * 虚拟银行账户变动信息Service业务层处理
 * 
 * @author ml
 * @date 2024-07-19
 */
@Service
public class VirtualbankaccountchangeServiceImpl implements IVirtualbankaccountchangeService 
{
    @Autowired
    private VirtualbankaccountchangeMapper virtualbankaccountchangeMapper;

    /**
     * 查询虚拟银行账户变动信息
     * 
     * @param id 虚拟银行账户变动信息主键
     * @return 虚拟银行账户变动信息
     */
    @Override
    public Virtualbankaccountchange selectVirtualbankaccountchangeById(Long id)
    {
        return virtualbankaccountchangeMapper.selectVirtualbankaccountchangeById(id);
    }

    /**
     * 查询虚拟银行账户变动信息列表
     * 
     * @param virtualbankaccountchange 虚拟银行账户变动信息
     * @return 虚拟银行账户变动信息
     */
    @Override
    public List<Virtualbankaccountchange> selectVirtualbankaccountchangeList(Virtualbankaccountchange virtualbankaccountchange)
    {
        return virtualbankaccountchangeMapper.selectVirtualbankaccountchangeList(virtualbankaccountchange);
    }

    /**
     * 新增虚拟银行账户变动信息
     * 
     * @param virtualbankaccountchange 虚拟银行账户变动信息
     * @return 结果
     */
    @Override
    public int insertVirtualbankaccountchange(Virtualbankaccountchange virtualbankaccountchange)
    {
        return virtualbankaccountchangeMapper.insertVirtualbankaccountchange(virtualbankaccountchange);
    }

    /**
     * 修改虚拟银行账户变动信息
     * 
     * @param virtualbankaccountchange 虚拟银行账户变动信息
     * @return 结果
     */
    @Override
    public int updateVirtualbankaccountchange(Virtualbankaccountchange virtualbankaccountchange)
    {
        virtualbankaccountchange.setUpdateTime(DateUtils.getNowDate());
        return virtualbankaccountchangeMapper.updateVirtualbankaccountchange(virtualbankaccountchange);
    }

    /**
     * 批量删除虚拟银行账户变动信息
     * 
     * @param ids 需要删除的虚拟银行账户变动信息主键
     * @return 结果
     */
    @Override
    public int deleteVirtualbankaccountchangeByIds(Long[] ids)
    {
        return virtualbankaccountchangeMapper.deleteVirtualbankaccountchangeByIds(ids);
    }

    /**
     * 删除虚拟银行账户变动信息信息
     * 
     * @param id 虚拟银行账户变动信息主键
     * @return 结果
     */
    @Override
    public int deleteVirtualbankaccountchangeById(Long id)
    {
        return virtualbankaccountchangeMapper.deleteVirtualbankaccountchangeById(id);
    }
}
