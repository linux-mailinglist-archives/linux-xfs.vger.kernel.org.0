Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 838D8186DA7
	for <lists+linux-xfs@lfdr.de>; Mon, 16 Mar 2020 15:44:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731558AbgCPOoq (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 16 Mar 2020 10:44:46 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:55686 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731551AbgCPOop (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 16 Mar 2020 10:44:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=eP59M3cTZDmWhFBAdaxhUAYxG6Roo+t6aeewlEh43+w=; b=lB4RNytHrEULLhaFGWtBydh5GB
        XDendmLtBX+dNWaMw7rmHlQq4X6Ycwfrl662vP/HIXcSmYg07zmHfKgeGUooAzVQkBktcnW+QOneV
        HNbOIp1pXN3+/lEvsPfyo9Pl+9IdpWBRss+swNV6yvnRFhU00aOub0+Y3YL0h/y0F17FHmBjeVWgC
        uwOFXxrjWAadH7GNcADpdjvWneaeUFiZu24wjWSH5bZ74MCiRyeUkmB0P//hABjWLFzQFiW+uWBC4
        71CbiUBF+tglYDVKkZ99rdgZqpR0yIM/GNyShdHgBZlk779DeyFS0C1vY77ZGOVRq0kvO1a4VdV4x
        U6oXZyRg==;
Received: from 089144202225.atnat0011.highway.a1.net ([89.144.202.225] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jDqyy-00050Z-VX; Mon, 16 Mar 2020 14:44:45 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     Dave Chinner <david@fromorbit.com>
Subject: cleanup log I/O error handling v2
Date:   Mon, 16 Mar 2020 15:42:19 +0100
Message-Id: <20200316144233.900390-1-hch@lst.de>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

this series cleans up the XFS log I/O error handling and removes the
XLOG_STATE_IOERROR iclog state.

Changes since v1:
 - split up more into more patches
 - additional refactoring
 - additional cleanups
 - dropped patches already merged
