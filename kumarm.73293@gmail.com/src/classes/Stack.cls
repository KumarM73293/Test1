/**
 * 
 * @Description Stack: a collection of ojbects that are inserted
 * and removed according to the last-in first-out principle. This 
 * implementaiton class include the main methods of the java.util.Stack
 * 
 * The class is generic which implies that a Stack can contain elements of any specified class
 * 
 * @aurthor Sinan Bunni
 * @group IMH Developers
 * @Date 28/11/2016
 * @see https://docs.oracle.com/javase/7/docs/api/java/util/Stack.html
 * 
**/
public class Stack {
    
    /**
     * 
     * @Description Generic list collection used to implement the stack
     * 
    **/
    private List<Object> elements { get; set; }
    
    public Stack() {
        this.elements = new List<Object>();
    }
    
	/**
	 * 
	 * @Description Return the number of eleemnts in the stack
	 * @return number of elements in the stack
	 * 
	**/
    public Integer size() {
        return this.elements.size();
    } //end size method
    
    /**
     * 
     * @Description Return whether the stack is empty
     * @return true if the stack is empty, false otherwise
     * 
     * 
    **/
    public Boolean isEmpty() {
        return size() == 0;
    } // end isEmtpy method
    
    /**
     * 
     * @Description Insertan element at the top of the stack
     * @param elementToPush element to be inserted.
     * 
    **/
    public void push(Object elementToPush) {
        this.elements.add(elementToPush);
    } // end push method
    
    /**
     * 
     * @Description Remvoe the top element from the stack
     * @return element remove
     * @exception StackFlowException if the stack is empty
     * 
     * 
    **/
    public Object pop() {
        if (isEmpty()) {
            throw new StackFlowException('pop underflow runtime error.');
        }
        
        return this.elements.remove(size() - 1);
    }// end pop method
    
    /**
     * 
     * @Description Inspect the element at the top of the stack.
     * @return top element in the stack
     * @exception StackFlowException if the stack is empty
     * 
    **/
    public Object peek() {
        if(isEmpty()) {
            throw new StackFlowException('peek underflow runtime error.');
        }
        
        return this.elements.get(size() - 1);
    } // end peek method
    
    /**
     * 
     * @Description Runtime exceptoin thrown when one tries to perform operation
     * peek or pop on an empty stack
     * 
    **/
    private class StackFlowException extends Exception {
        
    } // end StackFlowException class

} // end Stack class