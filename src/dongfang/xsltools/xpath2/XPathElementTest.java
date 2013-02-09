/* Generated By:JJTree: Do not edit this line. XPathElementTest.java */

package dongfang.xsltools.xpath2;

import java.util.Collections;
import java.util.Set;

import org.dom4j.QName;

import dongfang.xsltools.exceptions.XSLToolsSchemaException;
import dongfang.xsltools.xmlclass.CharGenerator;
import dongfang.xsltools.xmlclass.schemaside.AttributeUse;
import dongfang.xsltools.xmlclass.schemaside.ElementUse;
import dongfang.xsltools.xmlclass.schemaside.SingleTypeXMLClass;
import dongfang.xsltools.xmlclass.xslside.CommentNT;
import dongfang.xsltools.xmlclass.xslside.ElementNT;
import dongfang.xsltools.xmlclass.xslside.NodeType;
import dongfang.xsltools.xmlclass.xslside.PINT;
import dongfang.xsltools.xmlclass.xslside.RootNT;
import dongfang.xsltools.xmlclass.xslside.TextNT;
import dongfang.xsltools.xmlclass.xslside.UndeclaredNodeType;

public class XPathElementTest extends XPathQNamedTypedNodeTest {
  boolean nillable;

  public XPathElementTest(int id) {
    super(id);
  }

  public XPathElementTest(XPathParser p, int id) {
    super(p, id);
  }

  void setNillable(boolean nillable) {
    this.nillable = nillable;
  }

  @Override
String getKindName() {
    return "element";
  }

  /**
   * We can only regard the typed element test as an untyped one, and just
   * ignore the type and nillable properties.
   */
  @Override
public Set<UndeclaredNodeType> etest(Set<UndeclaredNodeType> delta) {
    QName qname = this.qname;
    if (qname == null)
      qname = NodeType.ANY_NAME;

    UndeclaredNodeType tester = new ElementNT(qname);
    if (delta.contains(NodeType.ONE_ANY_NAME_ELEMENT_NT))
      return Collections.singleton(tester);
    if (delta.contains(tester))
      return Collections.singleton(tester);
    return Collections.emptySet();
  }

  @Override
  boolean accept(CommentNT nt) {
    return false;
  }

  @Override
  public boolean accept(AttributeUse nt, SingleTypeXMLClass clazz) {
    return false;
  }

  @Override
  public boolean accept(ElementUse nt, SingleTypeXMLClass clazz)
      throws XSLToolsSchemaException {
    if (typeQName == null) {
      // case: no type
      if (getQName().getName().equals("*"))
        return true;
      return getQName().equals(nt.getQName());
    }
    if (getQName().getName().equals("*")) {
      // case: typed
      // TODO: Niller semantics!
      return nt.typeMayDeriveFrom(typeQName) && (nillable || !nt.isNilled());
    }
    return getQName().equals(nt.getQName()) && nt.typeMayDeriveFrom(typeQName)
        && (nillable || !nt.isNilled());
  }

  @Override
  boolean accept(PINT nt) {
    return false;
  }

  @Override
  boolean accept(RootNT nt, SingleTypeXMLClass clazz) {
    return false;
  }

  @Override
  boolean accept(TextNT nt) {
    return false;
  }

  @Override
public String toString() {
    String result = super.toString();
    if (nillable) {
      result = result.substring(0, result.length() - 1);
      result += "?)";
    }
    return result;
  }

  @Override
  public String testAttributeAxisRegExp(SingleTypeXMLClass clazz) {
    return "" + CharGenerator.getAbsurdChar();
  }

  @Override
  public String testSDOSAxisRegExp(SingleTypeXMLClass clazz)
      throws XSLToolsSchemaException {
    return testCDAxisRegExp(clazz);
  }

  @Override
  public String testCDAxisRegExp(SingleTypeXMLClass clazz)
      throws XSLToolsSchemaException {
    QName name = getQName();
    if (name.getName().equals("*"))
      return clazz.getElementRegExp();
    return "" + clazz.getCharForElementName(name);
  }
}