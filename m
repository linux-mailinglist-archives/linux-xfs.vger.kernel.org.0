Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DF6E34A157
	for <lists+linux-xfs@lfdr.de>; Fri, 26 Mar 2021 07:01:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229869AbhCZGAv (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 26 Mar 2021 02:00:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229882AbhCZGAq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 26 Mar 2021 02:00:46 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1245C0613AA
        for <linux-xfs@vger.kernel.org>; Thu, 25 Mar 2021 23:00:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=l2WBiCb5duYJRA9nKpihqrJOH1Qjg6utSrFiu8qAdtc=; b=k8fxbFX+cYrKW+5+/sOIGFT3hK
        K40cJnr7CC0ocPyjGzftHNDSN9TYIMbymJDU8/U57YACSZqxacszhQuwI3QbiJHDYSnuvvqFLr3+c
        f1oYFE0BfUwKDDEki0ysMi1J7aJ1JrdEamAeqyTsPnCTCV0a2zWzvOWT5pii3rxI7V1+USh7Guicc
        3GObXm9HMc+ogw4Pyfl6OvDuvVRVLfySf8qekMTk1JQquyJk5kIlEHFdGwyOfjnykMaXw5VlEmJdX
        pmPaL0O5fgShfi4/+U09MyBS2arGmo4DuCoSKiu7lgfWDVobGK9o6AnQVel/4zNCwJJQRnJ4YZEYz
        RFAbh9gQ==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lPfWU-00EMV3-G4; Fri, 26 Mar 2021 06:00:42 +0000
Date:   Fri, 26 Mar 2021 06:00:42 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org
Subject: Re: [PATCH 2/2] xfs: move the check for post-EOF mappings into
 xfs_can_free_eofblocks
Message-ID: <20210326060042.GB3421955@infradead.org>
References: <161671805938.621829.266575450099624132.stgit@magnolia>
 <161671807074.621829.1806705819432894284.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161671807074.621829.1806705819432894284.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
