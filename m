Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92C622282DE
	for <lists+linux-xfs@lfdr.de>; Tue, 21 Jul 2020 16:54:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728342AbgGUOyk (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 21 Jul 2020 10:54:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726710AbgGUOyk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 21 Jul 2020 10:54:40 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BBBEC061794
        for <linux-xfs@vger.kernel.org>; Tue, 21 Jul 2020 07:54:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=KPOt2J3aH3GDTlYtvCytnyzIBpxTaIdjzK5IoRljWZI=; b=JgOeg2ZRCWEgz9WceJCAtqqyT7
        b9H1iXR8pQIoNcR9jFRa/Derqk0BAZZuBpeXiCQFzzCdblLVf8ghPpeTQesZkbUc1vjqkqE3Ue6tu
        2YrR6/jWgHZYrwgNa0f7FwJH3sGhtoSwP06ikixpKY0DGzsd0S4/zVxKsbQYamqroKs0YUZHM0veX
        tjn4fXeebKhZ88Vnqd/unj5x22LdUlhQYReWXh4N5SRwWW1xr8uhxq33cklVH6c7Ir2a+tnpXXOY8
        qjGRyUbNHQXwuMph8835tsHcl3Duc1tLConkV4Az+8A5N91853aSZx9mcLeiU5Wzz8JlyWmTmH/I+
        N04z2PvQ==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jxtfC-0001eN-LV; Tue, 21 Jul 2020 14:54:38 +0000
Date:   Tue, 21 Jul 2020 15:54:38 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 02/11] xfs: rename XFS_DQ_{USER,GROUP,PROJ} to
 XFS_DQTYPE_*
Message-ID: <20200721145438.GB6208@infradead.org>
References: <159488191927.3813063.6443979621452250872.stgit@magnolia>
 <159488193224.3813063.12478435320438781308.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <159488193224.3813063.12478435320438781308.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jul 15, 2020 at 11:45:32PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> We're going to split up the incore dquot state flags from the ondisk
> dquot flags (eventually renaming this "type") so start by renaming the
> three flags and the bitmask that are going to participate in this.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
