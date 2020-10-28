Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EEE1129D474
	for <lists+linux-xfs@lfdr.de>; Wed, 28 Oct 2020 22:52:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728284AbgJ1VwN (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 28 Oct 2020 17:52:13 -0400
Received: from casper.infradead.org ([90.155.50.34]:44160 "EHLO
        casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728282AbgJ1VwM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 28 Oct 2020 17:52:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=se3UfqP5NOkZjR0wmIrgJpULERaaBNHBk7s+p0fv1oA=; b=NYmW3yHaIobYykA3ocbYBUrnEQ
        lWuAEl06aDJ5Vp8dO2aCHa8Sghe0QsgMFQ4BPEtkjcIbNkgQtWIV+qoFH8nknxJO9hL+PfaPYTQz5
        d5HEolUPzoVxsJvZZ2rBmsrIXrO6PHeio/fYp4/ZNoGW7NPvyr75jYfSH1zIZckOksZBusIM0JXUl
        3CEtD02bvZ9JfJRIRzEFCXDUfsH7GsPuqBOF8sXqZusHmUKJLfAdOJ05B8pSB608n3N00efn+V8HS
        R4lsfZ6W8JUnNJ2S5nfnRy+qErgaeSzFGQu1asLXyzqDG1My5hHtfGSi7QqCbWw1lLwToEr7kEEdS
        mbWXfAPw==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kXg5f-0000nT-8T; Wed, 28 Oct 2020 07:41:51 +0000
Date:   Wed, 28 Oct 2020 07:41:51 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     guaneryu@gmail.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org
Subject: Re: [PATCH 3/9] xfs/341: fix test when rextsize > 1
Message-ID: <20201028074151.GC2750@infradead.org>
References: <160382528936.1202316.2338876126552815991.stgit@magnolia>
 <160382530837.1202316.5888266175366678239.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <160382530837.1202316.5888266175366678239.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Oct 27, 2020 at 12:01:48PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Fix this test so that it works when the rt extent size is larger than
> single block.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
