Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6FEE434F5B
	for <lists+linux-xfs@lfdr.de>; Tue,  4 Jun 2019 19:54:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726465AbfFDRyn (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 4 Jun 2019 13:54:43 -0400
Received: from verein.lst.de ([213.95.11.211]:37808 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726295AbfFDRyn (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 4 Jun 2019 13:54:43 -0400
Received: by newverein.lst.de (Postfix, from userid 2407)
        id 31CCF68B05; Tue,  4 Jun 2019 19:54:18 +0200 (CEST)
Date:   Tue, 4 Jun 2019 19:54:17 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Subject: Re: use bios directly in the log code v2
Message-ID: <20190604175417.GA27561@lst.de>
References: <20190603172945.13819-1-hch@lst.de> <20190603173506.GC5390@magnolia> <20190603173816.GA2162@lst.de> <20190604172531.GA1200449@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190604172531.GA1200449@magnolia>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jun 04, 2019 at 10:25:31AM -0700, Darrick J. Wong wrote:
> I assume you're going to resubmit the other log item cleanup series at
> some point, right? :)

Yes.  I've been waiting for Brian to finish reviewing the remaining
patches before resending it.
