Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0816354D10
	for <lists+linux-xfs@lfdr.de>; Tue, 25 Jun 2019 13:01:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727705AbfFYLBH (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 25 Jun 2019 07:01:07 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:36924 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726419AbfFYLBH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Jun 2019 07:01:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=qMEl4XxpShRakIbrs5x3jJvP9Iejisc8dLjahLHhhKo=; b=PpZaKItABh0zEJRdWK/4cmZ6B
        +jHXV2EVJaOFxD/J8xhA9FW+lrnE8vhCBTgrJILCG3Q0oD98SO9rQX6E/ZZtbPmP8F9j2R7KOh2I+
        GbiM8B0ACD8rz/P3124fQlHfO6WEfGQuykZ512MEZhEtlRj331L4bgzMzP/6yzJxuGsfn4ReyJRwC
        4YVifWzX8wKrg8TaPZHNZ3jNZgk/Jd7eXzdenYBHvmkF9Duy+imYYiBtvnULNwB6iwzyjRjFQVQSU
        L3criKj6RffAolAroWOn5rMeAdXgcUMe9hS8fDw6NHdJA33cGrycGR8DRnmha0LINOQKzG5ywGKtZ
        3kgH/SFVg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92 #3 (Red Hat Linux))
        id 1hfjCE-0002XE-OF; Tue, 25 Jun 2019 11:01:06 +0000
Date:   Tue, 25 Jun 2019 04:01:06 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Eric Sandeen <sandeen@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 01/11] xfs_estimate: remove unneeded includes
Message-ID: <20190625110106.GA9601@infradead.org>
References: <1561066174-13144-1-git-send-email-sandeen@redhat.com>
 <1561066174-13144-2-git-send-email-sandeen@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1561066174-13144-2-git-send-email-sandeen@redhat.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jun 20, 2019 at 04:29:24PM -0500, Eric Sandeen wrote:
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
