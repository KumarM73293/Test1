/**
 * 
 * @Description A node in a Tree data structure. Tree is a collection of nodes
 * Defines the minimum requirements for an object that can be used as a Tree node
 * in the Rule Engine.
 * 
 * 
 * @author Sinan Bunni
 * @group IMH Developers
 * @data 01/12/2016
 * 
**/
public class Node {
    
    /**
     * 
     * Representation of the Node pointer
     * either on the left subtree or the right subtree
     * 
    **/
    public Node leftNode { get; private set; }
    public Node rightNode { get; private set; }
    
    public void setLeftNode(Node left) {
        leftNode = left;
    }
    
    public void setRightNode(Node right) {
        rightNode = right;
    }
    
    /**
     * 
     * The leaves are usually values either True (t) or False (f)
     * The non-leaves are operations either AND (a) or OR (o)
     * 
    **/
    public Boolean isLeaf { get; private set; }
    
    public void setIsLeaf(Boolean value) {
        isLeaf = value;
    }

    /**
     * 
     * The value is either True or False 
     * True as 't' and False as 'f'
     * 
    **/ 
    public String value { get; private set; }
    
    public void setValue(String operand) {
        value = operand;
    }
    
    /**
     * 
     * The operation is either AND or OR
     * AND as 'a' and Or as 'o'
     * 
    **/
    public String operation { get; private set; }
    
    public void setOperation(String op) {
        operation = op;
    }
    
    /**
     * 
     * An non argument constructor - represent an empty node
     * 
    **/
    public Node() {
        leftNode  = NULL;
        rightNode = NULL;
        isLeaf    = false;
        operation = NULL;
        value     = NULL;
    }

} // end Node class