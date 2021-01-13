Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEB8E2F4E10
	for <lists+linux-xfs@lfdr.de>; Wed, 13 Jan 2021 16:04:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725824AbhAMPA6 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 13 Jan 2021 10:00:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725747AbhAMPA5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 13 Jan 2021 10:00:57 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48FB6C061575
        for <linux-xfs@vger.kernel.org>; Wed, 13 Jan 2021 07:00:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=kJ+wwatr903B5a4JoKd6BYgx1mNrmpR6A9gzGGudL+Q=; b=IMQiCxvAWOWPSdGoMcsSZPamyb
        RS2l0UtJeJ8FqR0qpdIAw/scb0B5pi7EQ7+TPoCN3gYplkOt/HAUWZKg4vsATn/MQwUAAmVEPnTqW
        4z7Vahgs7RxiZs2UUrf9+PdCwpdUHCOXtbkVybWWUxNt9m9jMZ3k/LGGFYbWKco9kgnxdShtKv0Js
        6xG0Z8PD2fOBMF/VTlRjyxNE+00Eg8dEjeLJ9kjF4lNVLZsmgcVlH3TWPEV3fGXxCqc+tgjEPAr/8
        CgAeFanC+h+ZxCPoP9q+GeJVjY2oVmwlPt28JcAqIlmuEZjD6sE0vIoIgZvzJZ5di9eYlNrFaGDEe
        jUVC9SSg==;
Received: from [2001:4bb8:19b:e528:d345:8855:f08f:87f] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1kzhcB-006O5h-92; Wed, 13 Jan 2021 14:59:26 +0000
Date:   Wed, 13 Jan 2021 15:59:13 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/7] xfs: consolidate incore inode radix tree
 posteof/cowblocks tags
Message-ID: <X/8Kwedt/T4BbVe7@infradead.org>
References: <161040739544.1582286.11068012972712089066.stgit@magnolia>
 <161040741435.1582286.3950020739629626839.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161040741435.1582286.3950020739629626839.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jan 11, 2021 at 03:23:34PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> The clearing of posteof blocks and cowblocks serve the same purpose:
> removing speculative block preallocations from inactive files.  We don't
> need to burn two radix tree tags on this, so combine them into one.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
