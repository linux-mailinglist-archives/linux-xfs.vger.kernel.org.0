Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 233E042AC3D
	for <lists+linux-xfs@lfdr.de>; Tue, 12 Oct 2021 20:51:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234176AbhJLSmO (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 12 Oct 2021 14:42:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:50428 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234947AbhJLSmJ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 12 Oct 2021 14:42:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A60DA60EDF;
        Tue, 12 Oct 2021 18:40:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1634064001;
        bh=4NlzI4dFxtFWsmK4HNOLFkn2j8KfMJnWPwZWKJPEPAI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=aLV8P7/TA7iQMJF0qaKt5ZKy+gE2TiiPu2nZqetOP9YyyAcsJo/jiZgNVzTU1lkT+
         2W/4JR9XszN9+PCKAd86SS6HZy4Utp+IQoI/3t8eWWfSQ4e0sZiWOtAYA0TYppiR0t
         YJo2Ed+MK8pToXyv2626yPlvlXLxExtGRpdF1Mv4=
Date:   Tue, 12 Oct 2021 11:39:57 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Alex Sierra <alex.sierra@amd.com>
Cc:     <Felix.Kuehling@amd.com>, <linux-mm@kvack.org>,
        <rcampbell@nvidia.com>, <linux-ext4@vger.kernel.org>,
        <linux-xfs@vger.kernel.org>, <amd-gfx@lists.freedesktop.org>,
        <dri-devel@lists.freedesktop.org>, <hch@lst.de>, <jgg@nvidia.com>,
        <jglisse@redhat.com>, <apopple@nvidia.com>
Subject: Re: [PATCH v1 00/12] MEMORY_DEVICE_COHERENT for CPU-accessible
 coherent device memory
Message-Id: <20211012113957.53f05928dd60f3686331fede@linux-foundation.org>
In-Reply-To: <20211012171247.2861-1-alex.sierra@amd.com>
References: <20211012171247.2861-1-alex.sierra@amd.com>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.31; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, 12 Oct 2021 12:12:35 -0500 Alex Sierra <alex.sierra@amd.com> wrote:

> This patch series introduces MEMORY_DEVICE_COHERENT, a type of memory
> owned by a device that can be mapped into CPU page tables like
> MEMORY_DEVICE_GENERIC and can also be migrated like MEMORY_DEVICE_PRIVATE.
> With MEMORY_DEVICE_COHERENT, we isolate the new memory type from other
> subsystems as far as possible, though there are some small changes to
> other subsystems such as filesystem DAX, to handle the new memory type
> appropriately.
> 
> We use ZONE_DEVICE for this instead of NUMA so that the amdgpu
> allocator can manage it without conflicting with core mm for non-unified
> memory use cases.
> 
> How it works: The system BIOS advertises the GPU device memory (aka VRAM)
> as SPM (special purpose memory) in the UEFI system address map.
> The amdgpu driver registers the memory with devmap as
> MEMORY_DEVICE_COHERENT using devm_memremap_pages.
> 
> The initial user for this hardware page migration capability will be
> the Frontier supercomputer project.

To what other uses will this infrastructure be put?

Because I must ask: if this feature is for one single computer which
presumably has a custom kernel, why add it to mainline Linux?

> Our nodes in the lab have .5 TB of
> system memory plus 256 GB of device memory split across 4 GPUs, all in
> the same coherent address space. Page migration is expected to improve
> application efficiency significantly. We will report empirical results
> as they become available.
> 
> This includes patches originally by Ralph Campbell to change ZONE_DEVICE
> reference counting as requested in previous reviews of this patch series
> (see https://patchwork.freedesktop.org/series/90706/). We extended
> hmm_test to cover migration of MEMORY_DEVICE_COHERENT. This patch set
> builds on HMM and our SVM memory manager already merged in 5.14.
> We would like to complete review and merge this migration patchset for
> 5.16.

