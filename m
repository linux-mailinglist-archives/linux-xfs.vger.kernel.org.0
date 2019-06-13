Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D77F43979
	for <lists+linux-xfs@lfdr.de>; Thu, 13 Jun 2019 17:14:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387607AbfFMPN5 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 13 Jun 2019 11:13:57 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:37714 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733196AbfFMPN5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 13 Jun 2019 11:13:57 -0400
Received: by mail-qt1-f193.google.com with SMTP id y57so23001097qtk.4
        for <linux-xfs@vger.kernel.org>; Thu, 13 Jun 2019 08:13:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=KkKhR2elMbqIQhtMNyRPKfFVISR0bn0T2g34f2r/Vr8=;
        b=SfHInPm3DzZYLPoEmUVQqUjB5LScF9DsUpJ4xj+NyGtlotEBCDOd7k0OAiLknLgpy1
         UwRMpQmGSzJF0gJD/kcFMjRmesoOZkKPKtk3EWMStIXtk1BSmgVZYNk1p6EKmXc4imPv
         1V1hEuNESlphnwH9Ffq42vPqvIo/88Zh85Tr1f4Tsa8YuL7Uls35977s64dpr/1WcL8J
         ZbYx/FYbcjhIEQbbmhQgdZInCU3g7QIDiBsNO/6qOPrD5yA2TBMRXmDe20WR5bhjdxVZ
         hMtmCv3lKFvdGH4OgmFjKOdFtkKSEmGywoQe1a2KSSYQTb19JMjkAlD66sOEA23ZLtm9
         d4ZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=KkKhR2elMbqIQhtMNyRPKfFVISR0bn0T2g34f2r/Vr8=;
        b=a3AGhwibTaOHpv9f1oBvcsfvAsb3j95f16QKflfFLQ2pBHyMPMwwvyhu9ETeJ5A7B9
         m62FP7DmDgpceBItHLERiy2Ydmf7ZZeGUZKrBWunYYh1lieVrbvNAYl9n2o9Ft27AU7N
         tzwSTVNPYZxIqdyWI6vKq4XUqOmt8qlbY8QaXny2/ykk8J4UXVWzmMFj7itx7XJZYAzY
         a3tdXhz2DNXR0Az3qRlsST7rDz5qTpVJfsXexP9KuUhpqoemXVxO6oVBwH5Lo0pWE5zp
         p38ncUAdNFtYqPM2lXTfKupxBAHgv1N/Z2knGury3tjNph7VDvMgl6XRLGrL/8n2QvNa
         4RhA==
X-Gm-Message-State: APjAAAWA+wN0m8DXEp7JYE3jTxLdpLtFmjHe5ei6epk8k3U1cmpvVe5f
        M51xd0qOrHakPoeKlmj/eat39Q==
X-Google-Smtp-Source: APXvYqxrIgS7SEgThFO4xWkROTtAeKu9gS/7k/Y8mWYSTA6O8BjyUZUk4XGZHPcLg6c7oSu9BznGCA==
X-Received: by 2002:ac8:2f90:: with SMTP id l16mr60699198qta.12.1560438835818;
        Thu, 13 Jun 2019 08:13:55 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-156-34-55-100.dhcp-dynamic.fibreop.ns.bellaliant.net. [156.34.55.100])
        by smtp.gmail.com with ESMTPSA id c18sm1546907qkk.73.2019.06.13.08.13.55
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 13 Jun 2019 08:13:55 -0700 (PDT)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1hbRQI-0001rX-U0; Thu, 13 Jun 2019 12:13:54 -0300
Date:   Thu, 13 Jun 2019 12:13:54 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Dan Williams <dan.j.williams@intel.com>
Cc:     Ira Weiny <ira.weiny@intel.com>, Jan Kara <jack@suse.cz>,
        Theodore Ts'o <tytso@mit.edu>,
        Jeff Layton <jlayton@kernel.org>,
        Dave Chinner <david@fromorbit.com>,
        Matthew Wilcox <willy@infradead.org>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        John Hubbard <jhubbard@nvidia.com>,
        =?utf-8?B?SsOpcsO0bWU=?= Glisse <jglisse@redhat.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-nvdimm <linux-nvdimm@lists.01.org>,
        linux-ext4 <linux-ext4@vger.kernel.org>,
        Linux MM <linux-mm@kvack.org>
Subject: Re: [PATCH RFC 00/10] RDMA/FS DAX truncate proposal
Message-ID: <20190613151354.GC22901@ziepe.ca>
References: <20190607121729.GA14802@ziepe.ca>
 <20190607145213.GB14559@iweiny-DESK2.sc.intel.com>
 <20190612102917.GB14578@quack2.suse.cz>
 <20190612114721.GB3876@ziepe.ca>
 <20190612120907.GC14578@quack2.suse.cz>
 <20190612191421.GM3876@ziepe.ca>
 <20190612221336.GA27080@iweiny-DESK2.sc.intel.com>
 <CAPcyv4gkksnceCV-p70hkxAyEPJWFvpMezJA1rEj6TEhKAJ7qQ@mail.gmail.com>
 <20190612233324.GE14336@iweiny-DESK2.sc.intel.com>
 <CAPcyv4jf19CJbtXTp=ag7Ns=ZQtqeQd3C0XhV9FcFCwd9JCNtQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPcyv4jf19CJbtXTp=ag7Ns=ZQtqeQd3C0XhV9FcFCwd9JCNtQ@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jun 12, 2019 at 06:14:46PM -0700, Dan Williams wrote:
> > Effectively, we would need a way for an admin to close a specific file
> > descriptor (or set of fds) which point to that file.  AFAIK there is no way to
> > do that at all, is there?
> 
> Even if there were that gets back to my other question, does RDMA
> teardown happen at close(fd), or at final fput() of the 'struct
> file'?

AFAIK there is no kernel side driver hook for close(fd). 

rdma uses a normal chardev so it's lifetime is linked to the file_ops
release, which is called on last fput. So all the mmaps, all the dups,
everything must go before it releases its resources.

Jason
