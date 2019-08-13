Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D641B8B78A
	for <lists+linux-xfs@lfdr.de>; Tue, 13 Aug 2019 13:48:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727440AbfHMLso (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 13 Aug 2019 07:48:44 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:46724 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725981AbfHMLso (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 13 Aug 2019 07:48:44 -0400
Received: by mail-qt1-f194.google.com with SMTP id j15so12384324qtl.13
        for <linux-xfs@vger.kernel.org>; Tue, 13 Aug 2019 04:48:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Zt45e40hCF0YCbbLZ0aQGoNlrA/sQl/2BzKPlIDcczo=;
        b=D9yc6YFGEplkH0AEJkqbv5QQ/YqFFErgaOhlLwwyajnLxYCmzuYuYjTPu5K8IzHc7W
         EHziDWuZnP0EJUoJorsIB/Vle5Jq4HW1ZePpJfpxeJ3PiL6g9IJgSG7a6i4U9+NgvGWa
         Ai92AkBB6qVdNZzDPFs/+bpyxdePG4eiTSYai6xHFsXo6eqanU0phpcPPEHhvrx1/xET
         /OrVUPcq3jLH3XTfzYOI9j16wl1cGoll9zeKlcNrafKlJBFPS3Xu3jF23bvmZsNJxEuE
         b6+41/KGpH+t1xSORBP9OYFknrdMrMYelZfdaoojCQpOYGYaQ11oiLC8AtSSDLjOlbXi
         Q++A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Zt45e40hCF0YCbbLZ0aQGoNlrA/sQl/2BzKPlIDcczo=;
        b=KoW2siDJ+HcvmgB2Sc9rfzW69Fm3XW9NBf6DLUOkUJmzfUyt5/PuW+ws/eZHjoZ7XQ
         EH7gMFiVWFRgz+a4bE/XsnHlnxOCddhrYj5Mfjp/waYVvB2/eHpbyx8Qsq4irBAfu/2/
         16DqB0XtsCPasdAl2vd/Oww/Or1gU12ksjk+QqKE0pqqfxm888gWfFGmr6OblCZfpEXs
         /zBXAHmm5s82R5ThlFBIyLceP86uWdH4p2RTAZT7yXROksydVW7YNyy4J/QmjdW6Klhq
         ZDioCM6RmeODG38BRbRGbu5YHFTDeR9QmtLfzns5pmK/zCiFtoMlXEIOrxkAdlikI2S3
         Pg7Q==
X-Gm-Message-State: APjAAAVDGz/5Es7CcL0q6p6eNMkGJhEPg6P64o8KZrxX2KhCapuIdPN3
        +fkO8HoDD6hO4ca/PUhHr40g/A==
X-Google-Smtp-Source: APXvYqw4TQlyWpH+GsoO+iiZQsGjdJlFsSEd7xLsZ4WRKAsozWVqNJgjFHJHWU5rc/t0VYgJHvE8mg==
X-Received: by 2002:a0c:ae35:: with SMTP id y50mr33835040qvc.204.1565696923435;
        Tue, 13 Aug 2019 04:48:43 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-156-34-55-100.dhcp-dynamic.fibreop.ns.bellaliant.net. [156.34.55.100])
        by smtp.gmail.com with ESMTPSA id m38sm12868061qta.43.2019.08.13.04.48.42
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 13 Aug 2019 04:48:42 -0700 (PDT)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1hxVIA-0007l2-Ec; Tue, 13 Aug 2019 08:48:42 -0300
Date:   Tue, 13 Aug 2019 08:48:42 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Ira Weiny <ira.weiny@intel.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>,
        Theodore Ts'o <tytso@mit.edu>,
        John Hubbard <jhubbard@nvidia.com>,
        Michal Hocko <mhocko@suse.com>,
        Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-nvdimm@lists.01.org,
        linux-ext4@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [RFC PATCH v2 16/19] RDMA/uverbs: Add back pointer to system
 file object
Message-ID: <20190813114842.GB29508@ziepe.ca>
References: <20190809225833.6657-1-ira.weiny@intel.com>
 <20190809225833.6657-17-ira.weiny@intel.com>
 <20190812130039.GD24457@ziepe.ca>
 <20190812172826.GA19746@iweiny-DESK2.sc.intel.com>
 <20190812175615.GI24457@ziepe.ca>
 <20190812211537.GE20634@iweiny-DESK2.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190812211537.GE20634@iweiny-DESK2.sc.intel.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Aug 12, 2019 at 02:15:37PM -0700, Ira Weiny wrote:
> On Mon, Aug 12, 2019 at 02:56:15PM -0300, Jason Gunthorpe wrote:
> > On Mon, Aug 12, 2019 at 10:28:27AM -0700, Ira Weiny wrote:
> > > On Mon, Aug 12, 2019 at 10:00:40AM -0300, Jason Gunthorpe wrote:
> > > > On Fri, Aug 09, 2019 at 03:58:30PM -0700, ira.weiny@intel.com wrote:
> > > > > From: Ira Weiny <ira.weiny@intel.com>
> > > > > 
> > > > > In order for MRs to be tracked against the open verbs context the ufile
> > > > > needs to have a pointer to hand to the GUP code.
> > > > > 
> > > > > No references need to be taken as this should be valid for the lifetime
> > > > > of the context.
> > > > > 
> > > > > Signed-off-by: Ira Weiny <ira.weiny@intel.com>
> > > > >  drivers/infiniband/core/uverbs.h      | 1 +
> > > > >  drivers/infiniband/core/uverbs_main.c | 1 +
> > > > >  2 files changed, 2 insertions(+)
> > > > > 
> > > > > diff --git a/drivers/infiniband/core/uverbs.h b/drivers/infiniband/core/uverbs.h
> > > > > index 1e5aeb39f774..e802ba8c67d6 100644
> > > > > +++ b/drivers/infiniband/core/uverbs.h
> > > > > @@ -163,6 +163,7 @@ struct ib_uverbs_file {
> > > > >  	struct page *disassociate_page;
> > > > >  
> > > > >  	struct xarray		idr;
> > > > > +	struct file             *sys_file; /* backpointer to system file object */
> > > > >  };
> > > > 
> > > > The 'struct file' has a lifetime strictly shorter than the
> > > > ib_uverbs_file, which is kref'd on its own lifetime. Having a back
> > > > pointer like this is confouding as it will be invalid for some of the
> > > > lifetime of the struct.
> > > 
> > > Ah...  ok.  I really thought it was the other way around.
> > > 
> > > __fput() should not call ib_uverbs_close() until the last reference on struct
> > > file is released...  What holds references to struct ib_uverbs_file past that?
> > 
> > Child fds hold onto the internal ib_uverbs_file until they are closed
> 
> The FDs hold the struct file, don't they?

Only dups, there are other 'child' FDs we can create

> > Now this has unlocked updates to that data.. you'd need some lock and
> > get not zero pattern
> 
> You can't call "get" here because I'm 99% sure we only get here when struct
> file has no references left...

Nope, like I said the other FDs hold the uverbs_file independent of
the struct file it is related too. 

This is why having a back pointer like this is so ugly, it creates a
reference counting cycle

Jason
