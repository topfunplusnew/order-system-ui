package org.dzu.system.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import java.util.List;
import org.dzu.system.domain.InvoiceOther;

/**
 * 商家直接给客户开发票Mapper接口
 * 
 * @author ml
 * @date 2024-07-29
 */
public interface InvoiceOtherMapper extends BaseMapper<InvoiceOther>
{
    /**
     * 查询商家直接给客户开发票
     * 
     * @param id 商家直接给客户开发票主键
     * @return 商家直接给客户开发票
     */
    public InvoiceOther selectInvoiceOtherById(Long id);

    /**
     * 查询商家直接给客户开发票列表
     * 
     * @param invoiceOther 商家直接给客户开发票
     * @return 商家直接给客户开发票集合
     */
    public List<InvoiceOther> selectInvoiceOtherList(InvoiceOther invoiceOther);

    /**
     * 新增商家直接给客户开发票
     * 
     * @param invoiceOther 商家直接给客户开发票
     * @return 结果
     */
    public int insertInvoiceOther(InvoiceOther invoiceOther);

    /**
     * 修改商家直接给客户开发票
     * 
     * @param invoiceOther 商家直接给客户开发票
     * @return 结果
     */
    public int updateInvoiceOther(InvoiceOther invoiceOther);

    /**
     * 删除商家直接给客户开发票
     * 
     * @param id 商家直接给客户开发票主键
     * @return 结果
     */
    public int deleteInvoiceOtherById(Long id);

    /**
     * 批量删除商家直接给客户开发票
     * 
     * @param ids 需要删除的数据主键集合
     * @return 结果
     */
    public int deleteInvoiceOtherByIds(Long[] ids);
}
