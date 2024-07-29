package org.dzu.system.mapper;

import java.util.List;
import org.dzu.system.domain.Virtualbankaccountchange;

/**
 * 虚拟银行账户变动信息Mapper接口
 * 
 * @author ml
 * @date 2024-07-29
 */
public interface VirtualbankaccountchangeMapper 
{
    /**
     * 查询虚拟银行账户变动信息
     * 
     * @param id 虚拟银行账户变动信息主键
     * @return 虚拟银行账户变动信息
     */
    public Virtualbankaccountchange selectVirtualbankaccountchangeById(Long id);

    /**
     * 查询虚拟银行账户变动信息列表
     * 
     * @param virtualbankaccountchange 虚拟银行账户变动信息
     * @return 虚拟银行账户变动信息集合
     */
    public List<Virtualbankaccountchange> selectVirtualbankaccountchangeList(Virtualbankaccountchange virtualbankaccountchange);

    /**
     * 新增虚拟银行账户变动信息
     * 
     * @param virtualbankaccountchange 虚拟银行账户变动信息
     * @return 结果
     */
    public int insertVirtualbankaccountchange(Virtualbankaccountchange virtualbankaccountchange);

    /**
     * 修改虚拟银行账户变动信息
     * 
     * @param virtualbankaccountchange 虚拟银行账户变动信息
     * @return 结果
     */
    public int updateVirtualbankaccountchange(Virtualbankaccountchange virtualbankaccountchange);

    /**
     * 删除虚拟银行账户变动信息
     * 
     * @param id 虚拟银行账户变动信息主键
     * @return 结果
     */
    public int deleteVirtualbankaccountchangeById(Long id);

    /**
     * 批量删除虚拟银行账户变动信息
     * 
     * @param ids 需要删除的数据主键集合
     * @return 结果
     */
    public int deleteVirtualbankaccountchangeByIds(Long[] ids);
}
