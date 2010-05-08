/*
 * FileBrowser.fx
 *
 * Created on Feb 17, 2010, 12:30:11 PM
 */

package filebrowser;

import javafx.scene.control.Label;
import javafx.scene.image.Image;
import javafx.scene.image.ImageView;
import javafx.scene.layout.Container;
import javafx.scene.text.Font;
import javafx.geometry.VPos;
import javafx.util.Sequences;

import java.io.File;
import java.util.Comparator;

import com.javafx.preview.control.TreeCell;
import com.javafx.preview.control.TreeItem;
import com.javafx.preview.control.TreeItemBase;
import com.javafx.preview.control.TreeView;

/**
 * @author Rakesh Menon
 */

def collapseImage = Image {
    url: "{__DIR__}images/collapse.png"
}
def expandImage = Image {
    url: "{__DIR__}images/expand.png"
}
def treeClosedImage = Image {
    url: "{__DIR__}images/tree_closed.png"
}
def treeOpenImage = Image {
    url: "{__DIR__}images/tree_open.png"
}
def fileImage = Image {
    url: "{__DIR__}images/file.png"
}

public class FileBrowser extends Container {

    // Selected File Path
    public-read var selectedFile = bind "{treeView.selectedItem.data}";

    def roots = File.listRoots();

    def treeView = TreeView {

        override var cellFactory = function() : TreeCell {
            def cell:TreeCell = TreeCell {
                disclosureNode: ImageView {
                    translateX: bind (cell.treeItem.level - (if (cell.treeView.showRoot) then 1 else 2)) + 6
                    image: bind if(cell.treeItem.expanded) { collapseImage } else { expandImage }
                    visible: bind ((cell.item != null) and (not cell.treeItem.leaf))
                }
                node: Label {
                    text: bind formatLabel(cell.item)
                    translateX: bind (cell.treeItem.level + 6)
                    graphic: ImageView {
                        image: bind formatImage(cell.item, cell.treeItem)
                    }
                    visible: bind (cell.item != null)
                }
            }
        }

        showRoot: false

        root: TreeItem {
            data: "ROOT"
            children: for(root in roots) {
                FileTreeItem { data: root }
            }
        }
    }

    def selectedFileLabel = Label {
        font: Font { size: 12 }
        text: bind "{treeView.selectedItem.data}"
        vpos: VPos.CENTER
    }

    init {
        children = [ selectedFileLabel, treeView ];
    }

    override function doLayout() : Void {
        def h = getNodePrefHeight(selectedFileLabel);
        layoutNode(treeView, 0, 0, width, height - h - 10);
        layoutNode(selectedFileLabel, 5, height - h - 5, width - 10, h + 5);
    }

    function formatLabel(data : Object) : String {

        if(data == null) { return ""; }

        if(data instanceof File) {
            var fileName = (data as File).getName();
            if((fileName != null) and (fileName.trim().length() > 0)) {
                return fileName;
            }
        }
        return "{data}";
    }

    function formatImage(data : Object, treeItem : TreeItemBase) : Image {

        if(data == null) { return null; }
        if(not (data instanceof File)) { return null; }

        if((data as File).isDirectory()) {
            if(treeItem.expanded) {
                return treeOpenImage;
            } else {
                return treeClosedImage;
            }
        }

        return fileImage;
    }
}

def fileComparator = FileComparator { };

class FileTreeItem extends TreeItem {

    override var createChildren = function(item:TreeItemBase) : TreeItemBase[] {

        var treeItemBase : TreeItemBase[] = [];

        var file = (item.data as File);

        if(file.isDirectory()) {
            var files = file.listFiles();
            if(files != null) {
                for(f in files) {
                    insert FileTreeItem { data: f } into treeItemBase;
                }
            }
        }

        Sequences.sort(treeItemBase, fileComparator) as TreeItemBase[];
    }

    override var isLeaf = function(item:TreeItemBase) : Boolean {
        return not (item.data as File).isDirectory();
    }
}

class FileComparator extends Comparator {

    override function compare(obj1 : Object, obj2 : Object) : Integer {

        if(not (obj1 instanceof TreeItemBase)) return -1;
        if(not (obj2 instanceof TreeItemBase)) return -1;

        def file1 = (obj1 as TreeItemBase).data as File;
        def file2 = (obj2 as TreeItemBase).data as File;
        
        if(file1.isDirectory() and file2.isDirectory()) {
            return file1.getName().compareToIgnoreCase(file2.getName());
        } else if(file1.isFile() and file2.isFile()) {
            return file1.getName().compareToIgnoreCase(file2.getName());
        } else if(file1.isFile()) return 1;
        
        return -1;
    }
}
