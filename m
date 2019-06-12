Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 399A142FC3
	for <lists+linux-xfs@lfdr.de>; Wed, 12 Jun 2019 21:14:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727875AbfFLTOY (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 12 Jun 2019 15:14:24 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:36616 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727672AbfFLTOY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 12 Jun 2019 15:14:24 -0400
Received: by mail-qt1-f196.google.com with SMTP id p15so360913qtl.3
        for <linux-xfs@vger.kernel.org>; Wed, 12 Jun 2019 12:14:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Q6iGM1TiupqbenVhxjWmtAI5HyN33SMdpalMPy6x5OY=;
        b=fKZgzRoQazhx2NyU0bXbVZS8dOqt2ksyWGIauwNWYHJH8kgsCVJI03c4N5lKN0UfbL
         Bhd0f7dzZ8VYCFXXU+aLJIcr64Q7WMzXQZhTBHMZGz5IhlK3ID/yDJO/l9SrdO5KfgqK
         Pzqt+w2uTJiIBcYRcbkg+zqo7JEvQt6YgPwzekPufoXbr56qiO4x0n/EncSJ7JDY0Ihx
         5v476nbYAMqpu7FcZAOCJM9Yr1cgH62Vahq2y1Hbu0KZAQpHI9vvaxHreBBJ1eHnpDXL
         1X7rLB8DRwb8xJ6R2YIgnjubs6XczMXMrodaik5vqBCeF/b9SQjTHUeI0/OO4EIsnzG3
         NonA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Q6iGM1TiupqbenVhxjWmtAI5HyN33SMdpalMPy6x5OY=;
        b=n4FRI6+fp0sUeYn9sktHP1IbvrNueWA7RtZtbO7ZHnoEzXrMufQz1cQ16xpc7RY3Pb
         depXZ006htm0NAgV1ABcECsYasfqiUQcZFqY//C5J6bwe5f7/EYPRNq/vWnKkkbcN/Kp
         HLT0UoejiJyWB40CoPdpu8BQh0SUoON/PJeTGHcgJZvWDeIzjqPqtAIzGQfyKrqwtcxm
         FetHgrYKlXMebc0qCdkVGukgcedm6fmvflAqrUWzxsIafaJNcOnQiKykK/TmK1T6caip
         yrX5+yeVbIxHLNxYYEqoSbXTN3ViPffQD6CG67KQZeJtFGyffstAiEqbwqgcS9YyfSJm
         E0Jw==
X-Gm-Message-State: APjAAAU3b/ABJ99R9r50E1c4vYPQud89Wum0q3fxZuklfq3Y9bamv3tj
        T16oEibmxpRBU4w4x/D/ycUbDg==
X-Google-Smtp-Source: APXvYqxNVQoMlV0omgFKo75Awgw9qRfhh6FBsXYbr1pvY1QOdw5O302UlF57KTTs2aFOEmTGVw1+7g==
X-Received: by 2002:aed:3a03:: with SMTP id n3mr38086132qte.85.1560366863270;
        Wed, 12 Jun 2019 12:14:23 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-156-34-55-100.dhcp-dynamic.fibreop.ns.bellaliant.net. [156.34.55.100])
        by smtp.gmail.com with ESMTPSA id e66sm296313qtb.55.2019.06.12.12.14.22
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 12 Jun 2019 12:14:22 -0700 (PDT)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1hb8hR-00037z-Na; Wed, 12 Jun 2019 16:14:21 -0300
Date:   Wed, 12 Jun 2019 16:14:21 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Jan Kara <jack@suse.cz>
Cc:     Ira Weiny <ira.weiny@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
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
Message-ID: <20190612191421.GM3876@ziepe.ca>
References: <20190606014544.8339-1-ira.weiny@intel.com>
 <20190606104203.GF7433@quack2.suse.cz>
 <20190606195114.GA30714@ziepe.ca>
 <20190606222228.GB11698@iweiny-DESK2.sc.intel.com>
 <20190607103636.GA12765@quack2.suse.cz>
 <20190607121729.GA14802@ziepe.ca>
 <20190607145213.GB14559@iweiny-DESK2.sc.intel.com>
 <20190612102917.GB14578@quack2.suse.cz>
 <20190612114721.GB3876@ziepe.ca>
 <20190612120907.GC14578@quack2.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190612120907.GC14578@quack2.suse.cz>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jun 12, 2019 at 02:09:07PM +0200, Jan Kara wrote:
> On Wed 12-06-19 08:47:21, Jason Gunthorpe wrote:
> > On Wed, Jun 12, 2019 at 12:29:17PM +0200, Jan Kara wrote:
> > 
> > > > > The main objection to the current ODP & DAX solution is that very
> > > > > little HW can actually implement it, having the alternative still
> > > > > require HW support doesn't seem like progress.
> > > > > 
> > > > > I think we will eventually start seein some HW be able to do this
> > > > > invalidation, but it won't be universal, and I'd rather leave it
> > > > > optional, for recovery from truely catastrophic errors (ie my DAX is
> > > > > on fire, I need to unplug it).
> > > > 
> > > > Agreed.  I think software wise there is not much some of the devices can do
> > > > with such an "invalidate".
> > > 
> > > So out of curiosity: What does RDMA driver do when userspace just closes
> > > the file pointing to RDMA object? It has to handle that somehow by aborting
> > > everything that's going on... And I wanted similar behavior here.
> > 
> > It aborts *everything* connected to that file descriptor. Destroying
> > everything avoids creating inconsistencies that destroying a subset
> > would create.
> > 
> > What has been talked about for lease break is not destroying anything
> > but very selectively saying that one memory region linked to the GUP
> > is no longer functional.
> 
> OK, so what I had in mind was that if RDMA app doesn't play by the rules
> and closes the file with existing pins (and thus layout lease) we would
> force it to abort everything. Yes, it is disruptive but then the app didn't
> obey the rule that it has to maintain file lease while holding pins. Thus
> such situation should never happen unless the app is malicious / buggy.

We do have the infrastructure to completely revoke the entire
*content* of a FD (this is called device disassociate). It is
basically close without the app doing close. But again it only works
with some drivers. However, this is more likely something a driver
could support without a HW change though.

It is quite destructive as it forcibly kills everything RDMA related
the process(es) are doing, but it is less violent than SIGKILL, and
there is perhaps a way for the app to recover from this, if it is
coded for it.

My preference would be to avoid this scenario, but if it is really
necessary, we could probably build it with some work.

The only case we use it today is forced HW hot unplug, so it is rarely
used and only for an 'emergency' like use case.

Jason
