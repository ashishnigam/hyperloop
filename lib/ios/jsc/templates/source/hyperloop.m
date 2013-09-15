/**
 * Copyright (c) 2013 by Appcelerator, Inc. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 *
 * This generated code and related technologies are covered by patents
 * or patents pending by Appcelerator, Inc.
 */
#import "hyperloop.h"

/**
 * create a JSPrivateObject for storage in a JSObjectRef
 */
JSPrivateObject* HyperloopMakePrivateObjectForID(id object)
{
	JSPrivateObject *p = (JSPrivateObject*)malloc(sizeof(JSPrivateObject));
	p->object = (void *)object;
	p->type = JSPrivateObjectTypeID;
	[object retain];
	return p;
}

/**
 * create a JSPrivateObject for storage in a JSObjectRef where the object is a JSBuffer *
 */
JSPrivateObject* HyperloopMakePrivateObjectForJSBuffer(JSBuffer *buffer)
{
	JSPrivateObject *p = (JSPrivateObject*)malloc(sizeof(JSPrivateObject));
	p->object = (void*)buffer;
	p->type = JSPrivateObjectTypeJSBuffer;
	return p;
}

/**
 * create a JSPrivateObject for storage in a JSObjectRef where the object is a Class
 */
JSPrivateObject* HyperloopMakePrivateObjectForClass(Class cls)
{
	JSPrivateObject *p = (JSPrivateObject*)malloc(sizeof(JSPrivateObject));
	p->object = (void*)cls;
	p->type = JSPrivateObjectTypeClass;
	return p;
}

/**
 * destroy a JSPrivateObject stored in a JSObjectRef
 */
void HyperloopDestroyPrivateObject(JSObjectRef object) 
{
	JSPrivateObject *p = (JSPrivateObject*)JSObjectGetPrivate(object);
	if (p!=NULL)
	{
		if (p->type == JSPrivateObjectTypeID)
		{
			id object = (id)p->object;
			[object release];
		}
		else if (p->type == JSPrivateObjectTypeJSBuffer)
		{
			JSBuffer *buffer = (JSBuffer*)p->object;
			free(buffer->buffer);
			free(buffer);
			buffer = NULL;
		}
		else if (p->type == JSPrivateObjectTypeClass)
		{
			Class cls = (Class)p->object;
			[cls release];
		}
		free(p);
		p = NULL;
		JSObjectSetPrivate(object,0);
	}
}

/**
 * return a JSPrivateObject as an ID (or nil if not of type JSPrivateObjectTypeID)
 */
id HyperloopGetPrivateObjectAsID(JSObjectRef object)
{
	JSPrivateObject *p = (JSPrivateObject*)JSObjectGetPrivate(object);
	if (p!=NULL)
	{
		if (p->type == JSPrivateObjectTypeID)
		{
			return (id)p->object;
		}
	}
	return nil;
}

/**
 * return a JSPrivateObject as a Class (or nil if not of type JSPrivateObjectTypeID)
 */
Class HyperloopGetPrivateObjectAsClass(JSObjectRef object)
{
	JSPrivateObject *p = (JSPrivateObject*)JSObjectGetPrivate(object);
	if (p!=NULL)
	{
		if (p->type == JSPrivateObjectTypeClass)
		{
			return (Class)p->object;
		}
	}
	return nil;
}

/**
 * return a JSPrivateObject as a JSBuffer (or NULL if not of type JSPrivateObjectTypeJSBuffer)
 */
JSBuffer* HyperloopGetPrivateObjectAsJSBuffer(JSObjectRef object)
{
	JSPrivateObject *p = (JSPrivateObject*)JSObjectGetPrivate(object);
	if (p!=NULL)
	{
		if (p->type == JSPrivateObjectTypeJSBuffer)
		{
			return (JSBuffer*)p->object;
		}
	}
	return NULL;
}

/**
 * return true if JSPrivateObject is of type
 */
bool HyperloopPrivateObjectIsType(JSObjectRef object, JSPrivateObjectType type) 
{
	JSPrivateObject *p = (JSPrivateObject*)JSObjectGetPrivate(object);
	if (p!=NULL)
	{
		return p->type == type;
	}
	return false;	
}

/**
 * raise an exception
 */
JSValueRef HyperloopMakeException(JSContextRef ctx, const char *error, JSValueRef *exception) 
{
	JSStringRef string = JSStringCreateWithUTF8CString(error);
	JSValueRef message = JSValueMakeString(ctx, string);
	JSStringRelease(string);
	*exception = JSObjectMakeError(ctx, 1, &message, 0);
	return JSValueMakeUndefined(ctx);
}

/**
 * return a string representation as a JSValueRef for an id
 */
JSValueRef HyperloopToString(JSContextRef ctx, id object)
{
    NSString *description = [object description];
    JSStringRef descriptionStr = JSStringCreateWithUTF8CString([description UTF8String]);
    JSValueRef result = JSValueMakeString(ctx, descriptionStr);
    JSStringRelease(descriptionStr);
    return result;
}