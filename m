Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F03D6356435
	for <lists+linux-xfs@lfdr.de>; Wed,  7 Apr 2021 08:39:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345660AbhDGGi0 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 7 Apr 2021 02:38:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233205AbhDGGi0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 7 Apr 2021 02:38:26 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EC69C06174A
        for <linux-xfs@vger.kernel.org>; Tue,  6 Apr 2021 23:38:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=l2WBiCb5duYJRA9nKpihqrJOH1Qjg6utSrFiu8qAdtc=; b=UX68jC6bBRGBUSfqj+EMoo3vKC
        88ikyQ4SWYN0qJIwJ9gUgjOxGXfglNNMdVdlTVI7cHeL9U7xrJ/XErjAqQ8Lv3a49hYE891dcgfu0
        KByqQc0iMATBZVM0A+N9Qj5q4YAMHTXs5RpfUMsLB6LUox1sQOP2F5a4L+RkAg9U3vx/rOHYN2oEg
        eZp5s9MjgNlrsDovsASo9UU/f1V/oSyrDhSEj+IOmeBA+nncGcLIRG+KqC2lWkCTSok4/asPVi0fk
        l98DtT+3Snc/CkXUkOdO9AlKGRprV8MGVHZ/BLa1Z+9sgNo1jTteQcZyd4K0z+IcsPvd8xQHzEtM5
        QLNMzSxA==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lU1p4-00E1fD-O2; Wed, 07 Apr 2021 06:38:00 +0000
Date:   Wed, 7 Apr 2021 07:37:54 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/4] xfs: drop unnecessary setfilesize helper
Message-ID: <20210407063754.GE3339217@infradead.org>
References: <20210405145903.629152-1-bfoster@redhat.com>
 <20210405145903.629152-5-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210405145903.629152-5-bfoster@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
