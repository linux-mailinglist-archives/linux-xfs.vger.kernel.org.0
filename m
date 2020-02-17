Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9E5F0161399
	for <lists+linux-xfs@lfdr.de>; Mon, 17 Feb 2020 14:34:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726646AbgBQNeL (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 17 Feb 2020 08:34:11 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:46146 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726492AbgBQNeK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 17 Feb 2020 08:34:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=chTRfyq4lXCwztlCJDXbnVDlLxrvJ8A8j5yTEvkIiKg=; b=ejnz4qE/G88L6kGeoFaPQ1J+WD
        or0AIA6S0la40pT9l7k1Smb/mZ2f1FfjjVd1SDgSQCviUzBWGX9o6fznpuTn6AKg5mmXCJrg//Lu0
        kgy9aTUUs1xnIkoaN2Srdh9m5xqVFNHLL8YtkqJCsQ+0tEaA5SAKoZh+4lJWVsS/ziVm8inOX9WMm
        tURhlEhbsJuVU8g5rj4TJWszEdmFp3xtxx9l4u00CLsapmqlfgPKcdkl9SSjiki6kutyGUYh+mha3
        t4oUwj1MNRpiINLSXtGnkNilyCb8CC63+LRRRgHWhvsXiXz4du9OKmhsoj/nt0kKaLhfS65O1896y
        O0FKBS6g==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1j3gXK-0000Yp-NL; Mon, 17 Feb 2020 13:34:10 +0000
Date:   Mon, 17 Feb 2020 05:34:10 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     Pavel Reichl <preichl@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v5 3/4] xfs: xfs_isilocked() can only check a single lock
 type
Message-ID: <20200217133410.GC31012@infradead.org>
References: <20200214185942.1147742-1-preichl@redhat.com>
 <20200214185942.1147742-3-preichl@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200214185942.1147742-3-preichl@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good,

although as a standalone fix this should really be first in the series.

Reviewed-by: Christoph Hellwig <hch@lst.de>
