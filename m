Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5B7C47F2CD
	for <lists+linux-xfs@lfdr.de>; Fri,  2 Aug 2019 11:51:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391469AbfHBJvX (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 2 Aug 2019 05:51:23 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:50996 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391833AbfHBJvU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 2 Aug 2019 05:51:20 -0400
Received: by mail-wm1-f68.google.com with SMTP id v15so67335965wml.0
        for <linux-xfs@vger.kernel.org>; Fri, 02 Aug 2019 02:51:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to:user-agent;
        bh=yWdHfQByPB8H5ZlxO9edETW0cXkZq9zodM+htrMfMeY=;
        b=fG54K+YCRX62ZNX89kcoBhYJfT1frZAqXBEedG9jBsBzileEEcoK4u1s5woOzj8ij0
         xstRPIS3i7b2BOi5KGLue3l+0br57ltSR6e/8ah3wy8fYX/U1m+UG11su+zXvyNppbyk
         KnsSDV1wmgPKF+e8oJ3OrIvXLaI6lJRlObrWWOz/qW1V3qdjzIDGOocHXmeFZl4wPLkz
         DovOL8Ytv6bqxu9ITTt26isQTAsgR69GUxMBMmPWLdjOxHS3MBSpiJSzs0jTHdMQ/dU+
         FOUKafIVI4Z9tu21IGs0+DGmY7uxi9N71WRFIi5xTMzp3wbrorZ93dWwwdbInM2IIJI4
         7lAw==
X-Gm-Message-State: APjAAAVoIm6zBMl7TAn7aO7oviZU74LuDqGLQYTkz3BiGbmgNYfj7eHw
        +lhm10tLWuUwSpAzcq/+azD9dQ==
X-Google-Smtp-Source: APXvYqyNVMyEGdSfvIrxi/ns6x+SkmzfG6eR+FMXBuXdR1a+NI3qK9hNTCoxt0ZuIJtAWdDADISYhQ==
X-Received: by 2002:a1c:c742:: with SMTP id x63mr4005098wmf.0.1564739478669;
        Fri, 02 Aug 2019 02:51:18 -0700 (PDT)
Received: from pegasus.maiolino.io (ip-89-103-126-188.net.upcbroadband.cz. [89.103.126.188])
        by smtp.gmail.com with ESMTPSA id a81sm80422761wmh.3.2019.08.02.02.51.17
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 02 Aug 2019 02:51:18 -0700 (PDT)
Date:   Fri, 2 Aug 2019 11:51:16 +0200
From:   Carlos Maiolino <cmaiolino@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-fsdevel@vger.kernel.org, hch@lst.de, adilger@dilger.ca,
        jaegeuk@kernel.org, miklos@szeredi.hu, rpeterso@redhat.com,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/9] fs: Move start and length fiemap fields into
 fiemap_extent_info
Message-ID: <20190802095115.bjz6ejbouif3wkbt@pegasus.maiolino.io>
Mail-Followup-To: "Darrick J. Wong" <darrick.wong@oracle.com>,
        linux-fsdevel@vger.kernel.org, hch@lst.de, adilger@dilger.ca,
        jaegeuk@kernel.org, miklos@szeredi.hu, rpeterso@redhat.com,
        linux-xfs@vger.kernel.org
References: <20190731141245.7230-1-cmaiolino@redhat.com>
 <20190731141245.7230-6-cmaiolino@redhat.com>
 <20190731232837.GZ1561054@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190731232837.GZ1561054@magnolia>
User-Agent: NeoMutt/20180716
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

> >  
> >  STATIC int
> >  xfs_vn_fiemap(
> > -	struct inode		*inode,
> > -	struct fiemap_extent_info *fieinfo,
> > -	u64			start,
> > -	u64			length)
> > +	struct inode		  *inode,
> > +	struct fiemap_extent_info *fieinfo)
> >  {
> > -	int			error;
> > +	u64	start = fieinfo->fi_start;
> > +	u64	length = fieinfo->fi_len;
> > +	int	error;
> 
> Would be nice if the variable name indentation was consistent here, but
> otherwise the xfs part looks ok.

These fields are removed on the next patch, updating it is really required?
> 
> >  
> >  	xfs_ilock(XFS_I(inode), XFS_IOLOCK_SHARED);
> >  	if (fieinfo->fi_flags & FIEMAP_FLAG_XATTR) {
> > diff --git a/include/linux/fs.h b/include/linux/fs.h
> > index d5e7c744aea6..7b744b7de24e 100644
> > --- a/include/linux/fs.h
> > +++ b/include/linux/fs.h
> > @@ -1705,11 +1705,14 @@ extern bool may_open_dev(const struct path *path);
> >   * VFS FS_IOC_FIEMAP helper definitions.
> >   */
> >  struct fiemap_extent_info {
> > -	unsigned int fi_flags;		/* Flags as passed from user */
> > -	unsigned int fi_extents_mapped;	/* Number of mapped extents */
> > -	unsigned int fi_extents_max;	/* Size of fiemap_extent array */
> > -	struct fiemap_extent __user *fi_extents_start; /* Start of
> > -							fiemap_extent array */
> > +	unsigned int	fi_flags;		/* Flags as passed from user */
> > +	u64		fi_start;
> > +	u64		fi_len;
> 
> Comments for these two new fields?

Sure, how about this:

       u64           fi_start;            /* Logical offset at which
                                             start mapping */
       u64           fi_len;              /* Logical length of mapping
                                             the caller cares about */


btw, Above indentation won't match final result


Christoph, may I keep your reviewed tag by updating the comments as above?
Otherwise I'll just remove your tag

> 
> --D
> 
> > +	unsigned int	fi_extents_mapped;	/* Number of mapped extents */
> > +	unsigned int	fi_extents_max;		/* Size of fiemap_extent array */
> > +	struct		fiemap_extent __user *fi_extents_start;	/* Start of
> > +								   fiemap_extent
> > +								   array */
> >  };
> >  int fiemap_fill_next_extent(struct fiemap_extent_info *info, u64 logical,
> >  			    u64 phys, u64 len, u32 flags);
> > @@ -1841,8 +1844,7 @@ struct inode_operations {
> >  	int (*setattr) (struct dentry *, struct iattr *);
> >  	int (*getattr) (const struct path *, struct kstat *, u32, unsigned int);
> >  	ssize_t (*listxattr) (struct dentry *, char *, size_t);
> > -	int (*fiemap)(struct inode *, struct fiemap_extent_info *, u64 start,
> > -		      u64 len);
> > +	int (*fiemap)(struct inode *, struct fiemap_extent_info *);
> >  	int (*update_time)(struct inode *, struct timespec64 *, int);
> >  	int (*atomic_open)(struct inode *, struct dentry *,
> >  			   struct file *, unsigned open_flag,
> > @@ -3199,11 +3201,10 @@ extern int vfs_readlink(struct dentry *, char __user *, int);
> >  
> >  extern int __generic_block_fiemap(struct inode *inode,
> >  				  struct fiemap_extent_info *fieinfo,
> > -				  loff_t start, loff_t len,
> >  				  get_block_t *get_block);
> >  extern int generic_block_fiemap(struct inode *inode,
> > -				struct fiemap_extent_info *fieinfo, u64 start,
> > -				u64 len, get_block_t *get_block);
> > +				struct fiemap_extent_info *fieinfo,
> > +				get_block_t *get_block);
> >  
> >  extern struct file_system_type *get_filesystem(struct file_system_type *fs);
> >  extern void put_filesystem(struct file_system_type *fs);
> > -- 
> > 2.20.1
> > 

-- 
Carlos
