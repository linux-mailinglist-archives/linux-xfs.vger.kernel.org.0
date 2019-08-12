Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E42B589F0E
	for <lists+linux-xfs@lfdr.de>; Mon, 12 Aug 2019 15:01:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728763AbfHLNAm (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 12 Aug 2019 09:00:42 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:39558 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728744AbfHLNAl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 12 Aug 2019 09:00:41 -0400
Received: by mail-qt1-f195.google.com with SMTP id l9so102571016qtu.6
        for <linux-xfs@vger.kernel.org>; Mon, 12 Aug 2019 06:00:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=v27wNdJ2y4fYwnlNFEt6zNAiJxMsGAli8ivaPg3wc1M=;
        b=LV/5e5bv9v8c9I7DK/4tP8vVkAv6ndU5JI38qUo1+2B1jfGlrpI06NbB/wUkGmGyeD
         KY3vx+BUEfWjNcT2jjwpyELSCXp7i7rhZc2KX9VIhPMNn4kdIu0t67lAdfyU9nekK3/L
         3MP+wXH4WlzFyTZrxx9Nd58XuCITcoHJXYChWbVPAs14UWUvJfZCxKp6aHXHdcIEep4x
         r+prD4FcMDTQq1FtSuu4IHqp4tIQ7RstC8NDn1Eia7VGs9b5kzm5e4WhAMu4VOynEmb3
         TrkDaFXVCw6fu3HohAu2/SmzPW7CoZVyBc26hhltk64h6IL73zahCzWzhawOMhGp4fqS
         1wtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=v27wNdJ2y4fYwnlNFEt6zNAiJxMsGAli8ivaPg3wc1M=;
        b=PUSMEOLhAA0mMMH60/azkH+Gl3KjvApYBkEiCIXDCzH4nsOL03VryFFMl2PbuqgHrI
         Znzx+mEl21Y5/GIkVCoBonr+GOvgHFmSzERMXYxaIDJQAcOe15lOUxQh0CE6TzxH3J2s
         VN+4Vli9SJye7rAW3o1SCkHCy284Z1tKDnY1lLaqnJI2VqwVfG641hw/u7Cmi7ANVcwB
         KAsYtAOBgXxIUclhL6fxl7+ha9HDppVlxWFtSpFzrqEG5Q71gus4gUehT17zgBbt+iGO
         SEW/1mbhCVUjx8ixkTHvTezREND0sdaVX48TMHEDfEK7tr8zr/UJj+Vhrai5DLerN2Iw
         QFWQ==
X-Gm-Message-State: APjAAAXXVw6t4ey2uqgV47YZIaXPyq3WPHF642A65b4h1bsE5AcCUCCR
        nrkXCAJ/ZRJ99SH/C3bouXlKuw==
X-Google-Smtp-Source: APXvYqyQID2HK/cSNFy0j5AldC0D5f58clAE4+2HeEw+kkaB2zL8GXSnMyU9v7OrdqZd4L0OHplsYg==
X-Received: by 2002:ac8:6c48:: with SMTP id z8mr18986870qtu.58.1565614840799;
        Mon, 12 Aug 2019 06:00:40 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-156-34-55-100.dhcp-dynamic.fibreop.ns.bellaliant.net. [156.34.55.100])
        by smtp.gmail.com with ESMTPSA id m27sm52693265qtu.31.2019.08.12.06.00.40
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 12 Aug 2019 06:00:40 -0700 (PDT)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1hx9wG-0007QV-0U; Mon, 12 Aug 2019 10:00:40 -0300
Date:   Mon, 12 Aug 2019 10:00:40 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     ira.weiny@intel.com
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
Message-ID: <20190812130039.GD24457@ziepe.ca>
References: <20190809225833.6657-1-ira.weiny@intel.com>
 <20190809225833.6657-17-ira.weiny@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190809225833.6657-17-ira.weiny@intel.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Aug 09, 2019 at 03:58:30PM -0700, ira.weiny@intel.com wrote:
> From: Ira Weiny <ira.weiny@intel.com>
> 
> In order for MRs to be tracked against the open verbs context the ufile
> needs to have a pointer to hand to the GUP code.
> 
> No references need to be taken as this should be valid for the lifetime
> of the context.
> 
> Signed-off-by: Ira Weiny <ira.weiny@intel.com>
>  drivers/infiniband/core/uverbs.h      | 1 +
>  drivers/infiniband/core/uverbs_main.c | 1 +
>  2 files changed, 2 insertions(+)
> 
> diff --git a/drivers/infiniband/core/uverbs.h b/drivers/infiniband/core/uverbs.h
> index 1e5aeb39f774..e802ba8c67d6 100644
> +++ b/drivers/infiniband/core/uverbs.h
> @@ -163,6 +163,7 @@ struct ib_uverbs_file {
>  	struct page *disassociate_page;
>  
>  	struct xarray		idr;
> +	struct file             *sys_file; /* backpointer to system file object */
>  };

The 'struct file' has a lifetime strictly shorter than the
ib_uverbs_file, which is kref'd on its own lifetime. Having a back
pointer like this is confouding as it will be invalid for some of the
lifetime of the struct.

Jason
