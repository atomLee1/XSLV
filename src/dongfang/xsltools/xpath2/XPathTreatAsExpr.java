/* Generated By:JJTree: Do not edit this line. XPathTreatAsExpr.java */

package dongfang.xsltools.xpath2;

public class XPathTreatAsExpr extends XPathBase implements XPathExpr {
  public XPathTreatAsExpr(int id) {
    super(id);
  }

  public XPathTreatAsExpr(XPathParser p, int id) {
    super(p, id);
  }

  public short getType() {
    return ((XPathExpr) jjtGetChild(0)).getType();
  }

  @Override
public String toString() {
    StringBuilder res = new StringBuilder();
    res.append(jjtGetChild(0).toString());
    if (jjtGetNumChildren() > 1) {
      res.append(" treat as ");
      res.append(jjtGetChild(1).toString());
    }
    return res.toString();
  }
}
