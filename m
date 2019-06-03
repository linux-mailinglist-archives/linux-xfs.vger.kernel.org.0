Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C1F8E336E4
	for <lists+linux-xfs@lfdr.de>; Mon,  3 Jun 2019 19:38:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727807AbfFCRim (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 3 Jun 2019 13:38:42 -0400
Received: from verein.lst.de ([213.95.11.211]:58778 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727159AbfFCRim (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 3 Jun 2019 13:38:42 -0400
Received: by newverein.lst.de (Postfix, from userid 2407)
        id CEC75227A81; Mon,  3 Jun 2019 19:38:16 +0200 (CEST)
Date:   Mon, 3 Jun 2019 19:38:16 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Subject: Re: use bios directly in the log code v2
Message-ID: <20190603173816.GA2162@lst.de>
References: <20190603172945.13819-1-hch@lst.de> <20190603173506.GC5390@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190603173506.GC5390@magnolia>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jun 03, 2019 at 10:35:06AM -0700, Darrick J. Wong wrote:
> On Mon, Jun 03, 2019 at 07:29:25PM +0200, Christoph Hellwig wrote:
> > Hi all,
> > 
> > this series switches the log writing and log recovery code to use bios
> > directly, and remove various special cases from the buffer cache code.
> > Note that I have developed it on top of the previous series of log item
> > related cleanups, so if you don't have that applied there is a small
> 
> Hmm, /I/ don't have that applied. :/
> 
> Can you resend that series in its current form with (or without) all the
> suggested review cleanups, please? :)

Actually that sentence above is stale.  It applied to v1, but not v2
or this v3.
