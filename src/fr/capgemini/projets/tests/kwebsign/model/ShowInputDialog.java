/**
 * 
 */
package fr.capgemini.projets.tests.kwebsign.model;

/**
 * @author dtadmi
 *
 */
import java.awt.GridLayout;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.text.NumberFormat;

import javax.swing.JButton;
import javax.swing.JFormattedTextField;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JPanel;

public class ShowInputDialog
{

	/**
	 * The x position of the origin of the rectangle to build
	 */
	private Integer x;
	/**
	 * The y position of the origin of the rectangle to build
	 */
	private Integer y;
	/**
	 * The height of the rectangle to build
	 */
	private Integer height;
	/**
	 * The width of the rectangle to build
	 */
	private Integer width;
	
	private JFrame frame;
	private JPanel panel;
	private GridLayout glayout;

	public ShowInputDialog(String title)
	{

		super();
		// TODO Auto-generated constructor stub

		frame = new JFrame(title);
		panel = new JPanel();

		glayout = new GridLayout(0, 4, 4, 4);
		panel.setLayout(glayout);		
		
	}

	/**
	 * @return the x
	 */
	public int getX()
	{

		return x;
	}

	/**
	 * @param x
	 *            the x to set
	 */
	public void setX(int x)
	{

		this.x = x;
	}

	/**
	 * @return the y
	 */
	public int getY()
	{

		return y;
	}

	/**
	 * @param y
	 *            the y to set
	 */
	public void setY(int y)
	{

		this.y = y;
	}

	/**
	 * @return the height
	 */
	public int getHeight()
	{

		return height;
	}

	/**
	 * @param height
	 *            the height to set
	 */
	public void setHeight(int height)
	{

		this.height = height;
	}

	/**
	 * @return the width
	 */
	public int getWidth()
	{

		return width;
	}

	/**
	 * @param width
	 *            the width to set
	 */
	public void setWidth(int width)
	{

		this.width = width;
	}
	
	/**
	 * @return the frame
	 */
	public JFrame getFrame()
	{
	
		return frame;
	}

	
	/**
	 * @param frame the frame to set
	 */
	public void setFrame(JFrame frame)
	{
	
		this.frame = frame;
	}

	
	/**
	 * @return the panel
	 */
	public JPanel getPanel()
	{
	
		return panel;
	}

	
	/**
	 * @param panel the panel to set
	 */
	public void setPanel(JPanel panel)
	{
	
		this.panel = panel;
	}

	
	/**
	 * @return the glayout
	 */
	public GridLayout getGlayout()
	{
	
		return glayout;
	}

	
	/**
	 * @param glayout the glayout to set
	 */
	public void setGlayout(GridLayout glayout)
	{
	
		this.glayout = glayout;
	}

	public void defineParametersInterface()
	{
		JLabel xLabel = new JLabel("x :");
		JLabel yLabel = new JLabel("y :");
		JLabel heightLabel = new JLabel("hauteur :");
		JLabel widthLabel = new JLabel("largeur :");

		final JFormattedTextField xtf = new JFormattedTextField(
				NumberFormat.getIntegerInstance());
		final JFormattedTextField ytf = new JFormattedTextField(
				NumberFormat.getIntegerInstance());
		final JFormattedTextField htf = new JFormattedTextField(
				NumberFormat.getIntegerInstance());
		final JFormattedTextField wtf = new JFormattedTextField(
				NumberFormat.getIntegerInstance());

		xtf.setColumns(3);
		ytf.setColumns(3);
		htf.setColumns(3);
		wtf.setColumns(3);

		panel.add(xLabel);
		panel.add(xtf);
		panel.add(yLabel);
		panel.add(ytf);
		panel.add(heightLabel);
		panel.add(htf);
		panel.add(widthLabel);
		panel.add(wtf);
		
		final JButton validButton = new JButton("Valider");

		try
		{
			validButton.addActionListener(new ActionListener()
			{

				public void actionPerformed(ActionEvent ae)
				{
					x = Integer.parseInt(xtf.getText());

					y = Integer.parseInt(ytf.getText());

					height = Integer.parseInt(htf.getText());

					width = Integer.parseInt(wtf.getText());
					
					frame.dispose();
					
					System.out.println(height);
					System.out.println(width);
					System.out.println(x);
					System.out.println(y);
				}
			});
		}
		catch (Exception e)
		{
			e.printStackTrace();
			System.out.print(e.getMessage());
		}

		panel.add(validButton);
		frame.add(panel);
		frame.setSize(400, 400);
		frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		frame.setVisible(true);
		
	}
	
	public void disposeFrame()
	{
		frame.dispose();
	}

	public static void main(String[] args)
	{

		String title = "Dimensions de la zone de signature";
		ShowInputDialog sid = new ShowInputDialog(title);
		sid.defineParametersInterface();
		
		/*System.out.println(sid.getHeight());
		System.out.println(sid.getWidth());
		System.out.println(sid.getX());
		System.out.println(sid.getY());*/			

	}
}
