package org.dzu.system.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import org.dzu.system.domain.InvoiceOut;

import java.util.List;

/**
 * 发票卖出信息Mapper接口
 * 
 * @author ml
 * @date 2024-07-29
 */
public interface InvoiceOutMapper extends BaseMapper<InvoiceOut>
{
    /**
     * 查询发票卖出信息
     * 
     * @param id 发票卖出信息主键
     * @return 发票卖出信息
     */
    public InvoiceOut selectInvoiceOutById(Long id);

    /**
     * 查询发票卖出信息列表
     * 
     * @param invoiceOut 发票卖出信息
     * @return 发票卖出信息集合
     */
    public List<InvoiceOut> selectInvoiceOutList(InvoiceOut invoiceOut);

    /**
     * 新增发票卖出信息
     * 
     * @param invoiceOut 发票卖出信息
     * @return 结果
     */
    public int insertInvoiceOut(InvoiceOut invoiceOut);

    /**
     * 修改发票卖出信息
     * 
     * @param invoiceOut 发票卖出信息
     * @return 结果
     */
    public int updateInvoiceOut(InvoiceOut invoiceOut);

    /**
     * 删除发票卖出信息
     * 
     * @param id 发票卖出信息主键
     * @return 结果
     */
    public int deleteInvoiceOutById(Long id);

    /**
     * 批量删除发票卖出信息
     * 
     * @param ids 需要删除的数据主键集合
     * @return 结果
     */
    public int deleteInvoiceOutByIds(Long[] ids);
}
