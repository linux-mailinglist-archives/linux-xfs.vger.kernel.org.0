Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01B8F324C63
	for <lists+linux-xfs@lfdr.de>; Thu, 25 Feb 2021 10:07:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234716AbhBYJFo (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 25 Feb 2021 04:05:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235260AbhBYJEH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 Feb 2021 04:04:07 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C3DBC061574
        for <linux-xfs@vger.kernel.org>; Thu, 25 Feb 2021 01:03:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=NPzymWGZFZtOe+/jKRLbVu5DHM/rAWyTP2BsW0jWWww=; b=QA7r4qEEeGlXXAOVROgvTH94VW
        Id/7moy4iV1+o3Fll8oljS+xs5+tc1AGL+7ZQh7KP8VAV3PTeCAuu/YxYjQ531aAV+TJtaqlcMko1
        UmH3yKKBsxP99hnspZNXm3lYg77S9SzUrUK0GvjULNGZ4H1WrK7tQtcYtN+ZUddGFWSz1CzdcA8m+
        HisEMu1jXpkiezDAMa4aGG1kpPMnjYQx3urVL/1ybRZwkld4B5OhBh5PVhmm0L0CRTkMzetW+TcBl
        pkjORRNvof8OddWcarwlPEMkw5oh1shzcP3ehsmPNL+kTN4PR3WvJx7/VqbSqvU996WbYFieng08J
        VmsD7TaQ==;
Received: from 213-225-9-156.nat.highway.a1.net ([213.225.9.156] helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lFCYI-00AUuV-1o; Thu, 25 Feb 2021 09:03:21 +0000
Date:   Thu, 25 Feb 2021 10:01:07 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 0/3] xfs: buffer log item optimisations
Message-ID: <YDdnU3XgNQ1LmuOa@infradead.org>
References: <20210223044636.3280862-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210223044636.3280862-1-david@fromorbit.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The whole series looks good to me:

Reviewed-by: Christoph Hellwig <hch@lst.de>
