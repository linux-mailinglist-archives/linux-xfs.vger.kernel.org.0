Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A44F21F6BE
	for <lists+linux-xfs@lfdr.de>; Wed, 15 May 2019 16:41:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726753AbfEOOlq (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 15 May 2019 10:41:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53872 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726452AbfEOOlq (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 15 May 2019 10:41:46 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 8223389C44;
        Wed, 15 May 2019 14:41:46 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 2B2C41001E98;
        Wed, 15 May 2019 14:41:46 +0000 (UTC)
Date:   Wed, 15 May 2019 10:41:44 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/6] xfs: refactor small allocation helper to skip cntbt
 attempt
Message-ID: <20190515144144.GD2898@bfoster>
References: <20190509165839.44329-1-bfoster@redhat.com>
 <20190509165839.44329-2-bfoster@redhat.com>
 <20190510172446.GA18992@infradead.org>
 <20190513154433.GD61135@bfoster>
 <20190515075253.GG29211@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190515075253.GG29211@infradead.org>
User-Agent: Mutt/1.11.3 (2019-02-01)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.27]); Wed, 15 May 2019 14:41:46 +0000 (UTC)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, May 15, 2019 at 12:52:53AM -0700, Christoph Hellwig wrote:
> On Mon, May 13, 2019 at 11:44:34AM -0400, Brian Foster wrote:
> > The only functional change was basically to check for ccur before using
> > it and initializing i to zero. It just seemed to make sense to clean up
> > the surrounding code while there, but I can either split out the
> > aesthetic cleanup or defer that stuff to the broader rework at the end
> > of the series (where the cursor stuff just gets ripped out anyways) if
> > either of those is cleaner..
> 
> Yeah, I noticed how trivial the actual change was.  That is why just
> doing the cleanup in pass 1 and applying the change in pass 2 might
> make it more readbale.  It might also be worth to throw in the use
> a goto label instead of long conditionals from your last patch into
> that cleanup prep patch.

Ok, I've lifted all of the small mode refactoring (from both this patch
and the last one) into an initial patch. Unless you indicate otherwise,
I've also retained your review tag(s), though you might want to take a
cursory look once the next version lands.

Brian
