Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 35B8E38E95
	for <lists+linux-xfs@lfdr.de>; Fri,  7 Jun 2019 17:10:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729106AbfFGPKR (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 7 Jun 2019 11:10:17 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:46426 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729853AbfFGPKR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 7 Jun 2019 11:10:17 -0400
Received: by mail-qt1-f196.google.com with SMTP id h21so2597985qtn.13
        for <linux-xfs@vger.kernel.org>; Fri, 07 Jun 2019 08:10:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=mtF5cAWsrYgtNZcy7Xm0z7hOgyvsIAMepLY84jhBIIY=;
        b=WYsyLuJwZJIQkQf8wUWCq+MKSRiYgAlB3cZg5uiR6sfXzmT5qRPbG9DhevssrlPWqT
         btVD4AS17pELyqwsgZDkQw2P7FuITtTVQMrN8ttsGMNW1xgfpIRPBVOa0vjh1b2Q1GR1
         KuOwYeQwWnuz6D+1FRguaiqcVs7bzdSKLArmkC9S3JiLqJpGoQtRUAt5WZRIgTPnLny4
         IKSY1gSwXGY6RvgI08IKQsXM6qG3PGhAf3b+OAJpaapDK96fRJ2kOM5Yvdls9VHMdofH
         LPFgCkV+imozC4VVLOAwHIKBZyqQ6Svl+UIUCGPXrQKi5OfcTa6MmnRnnxQ4x38JcA+k
         g4gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=mtF5cAWsrYgtNZcy7Xm0z7hOgyvsIAMepLY84jhBIIY=;
        b=R6NSeX8oYfBt4LEalI6dGwbSgJ2AtN5Pqj0+6ulj2CmbJoMq3+HXXslkvEvRyfnHyK
         aC9/cn9S34soyZ5+rWKu01oAFMo4ksepSpClPotnNzvkhplb/2i4tfADw+GuxtGShYfW
         1u7e8hSEPnTa2Aw9avEZyM7e+PNxTKWAY6u6ZXY0PsoipI1jBv+SrOmtmlIZkH9miUBZ
         fstgyKjawa6nWHMzVzwwdYSFPh77jcBBqMm2DRHNCdHjhJNFlWDBIo+d2uRL4c+pP+Yn
         R8IDolJnjYCkeGtwh9/bJAbcT3DE2SkYRRFHkzscW01Fk1VeE9SApi10TQhxQTXym97z
         EI7Q==
X-Gm-Message-State: APjAAAUUoFQqcxvjURVT/A6+lFlA3gw2YD7uCObGdfJ0F+po0Jd+//lj
        s1Dc53pJ/rn2Q8ozCTWC7NADwA==
X-Google-Smtp-Source: APXvYqz98pAEW8JOYRDiw9EYF+WsmnpCH5t6BgflMJ4duW3xWG4TSqN3U+4KRrwB7XAG90R+0pkeHA==
X-Received: by 2002:ac8:4619:: with SMTP id p25mr14877922qtn.73.1559920216042;
        Fri, 07 Jun 2019 08:10:16 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-156-34-55-100.dhcp-dynamic.fibreop.ns.bellaliant.net. [156.34.55.100])
        by smtp.gmail.com with ESMTPSA id a11sm1103592qkn.26.2019.06.07.08.10.15
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 07 Jun 2019 08:10:15 -0700 (PDT)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1hZGVT-0006TX-4L; Fri, 07 Jun 2019 12:10:15 -0300
Date:   Fri, 7 Jun 2019 12:10:15 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Ira Weiny <ira.weiny@intel.com>
Cc:     Jan Kara <jack@suse.cz>, Dan Williams <dan.j.williams@intel.com>,
        Theodore Ts'o <tytso@mit.edu>,
        Jeff Layton <jlayton@kernel.org>,
        Dave Chinner <david@fromorbit.com>,
        Matthew Wilcox <willy@infradead.org>,
        linux-xfs@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        John Hubbard <jhubbard@nvidia.com>,
        =?utf-8?B?SsOpcsO0bWU=?= Glisse <jglisse@redhat.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-nvdimm@lists.01.org, linux-ext4@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH RFC 00/10] RDMA/FS DAX truncate proposal
Message-ID: <20190607151015.GJ14802@ziepe.ca>
References: <20190606014544.8339-1-ira.weiny@intel.com>
 <20190606104203.GF7433@quack2.suse.cz>
 <20190606195114.GA30714@ziepe.ca>
 <20190606222228.GB11698@iweiny-DESK2.sc.intel.com>
 <20190607103636.GA12765@quack2.suse.cz>
 <20190607121729.GA14802@ziepe.ca>
 <20190607145213.GB14559@iweiny-DESK2.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190607145213.GB14559@iweiny-DESK2.sc.intel.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jun 07, 2019 at 07:52:13AM -0700, Ira Weiny wrote:
> On Fri, Jun 07, 2019 at 09:17:29AM -0300, Jason Gunthorpe wrote:
> > On Fri, Jun 07, 2019 at 12:36:36PM +0200, Jan Kara wrote:
> > 
> > > Because the pins would be invisible to sysadmin from that point on. 
> > 
> > It is not invisible, it just shows up in a rdma specific kernel
> > interface. You have to use rdma netlink to see the kernel object
> > holding this pin.
> > 
> > If this visibility is the main sticking point I suggest just enhancing
> > the existing MR reporting to include the file info for current GUP
> > pins and teaching lsof to collect information from there as well so it
> > is easy to use.
> > 
> > If the ownership of the lease transfers to the MR, and we report that
> > ownership to userspace in a way lsof can find, then I think all the
> > concerns that have been raised are met, right?
> 
> I was contemplating some new lsof feature yesterday.  But what I don't think we
> want is sysadmins to have multiple tools for multiple subsystems.  Or even have
> to teach lsof something new for every potential new subsystem user of GUP pins.

Well.. it is a bit tricky, but you'd have to arrange for the lease
object to have a list of 'struct files' that are holding the
lease open. 

The first would be the file that did the fcntl, the next would be all
the files that did longterm GUP - which means longterm GUP has to have
a chardev file/etc as well (seems OK)

Then lsof could query the list of lease objects for each file it
encounters and print them out too.

Jason
