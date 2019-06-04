Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E4C4D34FF0
	for <lists+linux-xfs@lfdr.de>; Tue,  4 Jun 2019 20:42:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726317AbfFDSmc (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 4 Jun 2019 14:42:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56682 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725933AbfFDSmc (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 4 Jun 2019 14:42:32 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 1FFC530BC58E;
        Tue,  4 Jun 2019 18:42:27 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id A66005B683;
        Tue,  4 Jun 2019 18:42:26 +0000 (UTC)
Date:   Tue, 4 Jun 2019 14:42:24 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        linux-xfs@vger.kernel.org
Subject: Re: use bios directly in the log code v2
Message-ID: <20190604184221.GB44563@bfoster>
References: <20190603172945.13819-1-hch@lst.de>
 <20190603173506.GC5390@magnolia>
 <20190603173816.GA2162@lst.de>
 <20190604172531.GA1200449@magnolia>
 <20190604175417.GA27561@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190604175417.GA27561@lst.de>
User-Agent: Mutt/1.11.3 (2019-02-01)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.49]); Tue, 04 Jun 2019 18:42:32 +0000 (UTC)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jun 04, 2019 at 07:54:17PM +0200, Christoph Hellwig wrote:
> On Tue, Jun 04, 2019 at 10:25:31AM -0700, Darrick J. Wong wrote:
> > I assume you're going to resubmit the other log item cleanup series at
> > some point, right? :)
> 
> Yes.  I've been waiting for Brian to finish reviewing the remaining
> patches before resending it.

I thought I made it through the last post of that series...

Brian
